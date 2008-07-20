#!/usr/bin/env python

import wsgiref.handlers
import zlib

from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache

import imdb

class SearchHandler(LookupHandler):
  def get_test(self):
    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    moviesElement = document.createElement("movies")
    resultElement.appendChild(moviesElement)

    movieElement = document.createElement("movie")
    movieElement.setAttribute("name", "Dark Kight, The")
    movieElement.setAttribute("year", "2008")
    movieElement.setAttribute("id", "0468569")
    moviesElement.appendChild(movieElement);

    self.response.out.write(document.toxml())

  def get(self):
    self.get_test()
    return

    q = self.request.get("q")
    listings = self.get_listings_from_cache(q)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings))


  def get_listings_from_cache(self, q):
    listings = memcache.get("Search_" + q)

    if listings is None:
      listings = self.get_listings_from_webservice(q)
      memcache.Client().set("Search_" + q, listings, time=24*60*60)

    return listings
    

  def get_listings_from_webservice(self, q):    
    i = imdb.IMDb(accessSystem='http')
    movies = i.search_movie(q)
    people = i.search_person(q)

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    moviesElement = document.createElement("movies")
    resultElement.appendChild(moviesElement)
    for m in movies:
        movieElement = document.createElement("movie")
        movieElement.setAttribute("name", m['canonical title'])
        movieElement.setAttribute("year", m['year'])
        movieElement.setAttribute("id", m.getID())
        moviesElement.appendChild(movieElement);
        
    peopleElement = document.createElement("people")
    resultElement.appendChild(peopleElement)
    for p in people:
        personElement = document.createElement("person")
        personElement.setAttribute("name", p['long imdb canonical name']) #unicode(p['long imdb canonical name'], "iso-8859-1"))
        personElement.setAttribute("id", p.getID())
        peopleElement.appendChild(personElement)
        
    return zlib.compress(resultElement.toxml("utf8"))
