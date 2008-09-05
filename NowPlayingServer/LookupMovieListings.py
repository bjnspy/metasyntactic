#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupMovieListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()
    q = self.request.get("q")
    hash = self.request.get("hash")
    format = self.request.get("format")

    if not (q == "RottenTomatoes" or q == "Metacritic"):
        q = "RottenTomatoes"

    if format != "tab" and format != "xml":
      format = "tab"

    if hash == "true":
      self.get_hash(q, format)
      return
    
    listings = self.get_listings_from_cache(q, format)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(listings)


  def get_keys(self, q, format):
    key = "MovieListings_" + q + "_" + format
    hash_key = key + "_Hash"

    return (key, hash_key)

  def get_hash(self, q, format):
    (key, hash_key) = self.get_keys(q, format)
    hash = memcache.get(hash_key)

    if hash is None:
      self.get_listings_from_cache(q, format)
      hash = memcache.get(hash_key)

    if hash is None:
      self.response.out.write("0")
    else:
      self.response.out.write(hash)
    

  def get_listings_from_cache(self, q, format):
    (key, hash_key) = self.get_keys(q, format)
    listings = memcache.get(key)

    if listings is None:
      listings = self.get_listings_from_webservice(q, format)
      if not listings is None:
        memcache.Client().set(key, listings, 4 * 60 * 60)
        memcache.Client().set(hash_key, str(hash(listings)), 2 * 60 * 60)

    if not listings is None and memcache.get(hash_key) is None:
      memcache.Client().set(hash_key, str(hash(listings)), 2 * 60 * 60)

    return listings
    

  def get_listings_from_rotten_tomatoes_webservice(self, q, format):
    url = "http://i.rottentomatoes.com/syndication/tab/complete_movies.txt"
    content = urlfetch.fetch(url).content
    encoded = unicode(content, "iso-8859-1")

    if encoded.find("Rotten Tomatoes is temporarily unavailable") > 0:
      return None
    
    if format == "tab":
      return encoded

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    for line in encoded.split("\n")[1:-1]:
      columns = line.split("\t")
      if len(columns) >= 9:
        title = columns[1]
        link = columns[2]
        score = columns[3]
        synopsis = columns[8]

        movieElement = document.createElement("movie")
        resultElement.appendChild(movieElement)

        movieElement.setAttribute("title", title)
        movieElement.setAttribute("link", link)
        movieElement.setAttribute("score", score)
        movieElement.setAttribute("synopsis", synopsis)

    return document.toxml()


  def get_listings_from_metacritic_webservice(self, q, format):
    url = "http://www.metacritic.com/film/"
    content = urlfetch.fetch(url).content
    content = unicode(content, "utf8")
 
    section1Start = content.find("<div id=\"sortbyname1\"")
    if section1Start < 0:
      return None
    
    section1End = content.find("<div id=\"sortbyscore1\"", section1Start)
    if section1End < 0:
      return None

    section2Start = content.find("<div id=\"sortbyname2\"", section1End)
    if section2Start < 0:
      return None
    
    section2End = content.find("<div id=\"sortbyscore2\"", section2Start)
    if section2End < 0:
      return None

    #self.response.out.write(str(section1Start) + " " + str(section1End) + " " + str(section2Start) + " " + str(section2End) + " ")
    
    reviews1 = self.extract_metacritic_reviews(content[section1Start:section1End])
    reviews2 = self.extract_metacritic_reviews(content[section2Start:section2End])

    reviews1.extend(reviews2)

    if format == "tab":
      result = u""
      for (score,link,title) in reviews1:
        if result != u"":
          result += u"\n"
        result += score + "\t" + link + "\t" + title

      return result
    else:
      document = getDOMImplementation().createDocument(None, "result", None)
      resultElement = document.documentElement

      for (score,link,title) in reviews1:
        movieElement = document.createElement("movie")
        resultElement.appendChild(movieElement)

        movieElement.setAttribute("title", title)
        movieElement.setAttribute("link", link)
        movieElement.setAttribute("score", score)
        movieElement.setAttribute("synopsis", u"")        

      return document.toxml()
    
    
  def extract_metacritic_reviews(self, content):
    sections = content.split("<SPAN")
    result = []
    
    for s in sections:
        startBracketIndex = s.find(">")
        if startBracketIndex < 0:
            continue
            
        endBracketIndex = s.find("</SPAN>", startBracketIndex)
        if endBracketIndex < 0:
            continue
        
        hrefIndex = s.find("<A HREF=\"", endBracketIndex)
        if hrefIndex < 0:
            continue
            
        linkStart = hrefIndex + len("<A HREF=\"")
        quoteIndex = s.find("\"", linkStart)
        if quoteIndex < 0:
            continue
            
        titleStart = s.find("<B>", quoteIndex)
        title = u""
        if titleStart > 0:
            titleEnd = s.find("</B>", titleStart)
            if titleEnd > 0:
                title = s[titleStart + len("<B>"):titleEnd]
        else:
            titleStart = s.find(">", quoteIndex)
            if titleStart > 0:
                titleEnd = s.find("<", titleStart)
                if titleEnd > 0:
                    title = s[titleStart + 1:titleEnd]
                    
        title = title.replace("&#039;", "'")
        score = s[startBracketIndex + 1:endBracketIndex]
        link = u"http://www.metacritic.com" + s[linkStart:quoteIndex]
        
        result.append((score,link,title))
        
    return result
    

  def get_listings_from_webservice(self, q, format):
    if q == "Metacritic":
        return self.get_listings_from_metacritic_webservice(q, format)
        
    if q == "RottenTomatoes":
        return self.get_listings_from_rotten_tomatoes_webservice(q, format)
        
    return None
