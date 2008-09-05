#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupRottenTomatoesReviews

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupMetacriticReviewsHandler(webapp.RequestHandler):
  def get_listings(self, content, format):
    sections  = self.extract_review_sections(content)

    if format == "tab":
      result = u""
      for s in sections:
        review = self.extract_review(s)
        if not review is None:
          (text, score, link, author, source) = review
          result += text + "\t" + score + "\t" + link + "\t" + author + "\t" + source
          result += u"\n"
    
      return result
    else:
      document = getDOMImplementation().createDocument(None, "result", None)
      resultElement = document.documentElement

      for s in sections:
        review = self.extract_review(s)
        if not review is None:
          (text, score, link, author, source) = review

          reviewElement = document.createElement("review")
          resultElement.appendChild(reviewElement)

          reviewElement.setAttribute("text", text)
          reviewElement.setAttribute("score", score)
          reviewElement.setAttribute("link", link)
          reviewElement.setAttribute("author", author)
          reviewElement.setAttribute("source", source)

      return document.toxml()
      
    
  def extract_review(self, section):
    text = self.extract_text(section)
    if text is None:
        return None
    
    score = self.extract_score(section)
    author = self.extract_author(section)
    source = self.extract_source(section)
    link = self.extract_link(section)
    
    text = self.replace_lines(text)
    link = self.replace_lines(link)
    author = self.replace_lines(author)
    source = self.replace_lines(source)
    
    return (text, score, link, author, source)

  
  def extract_score(self, section):
    scoreStart = section.find("<div class=\"criticscore\">")
    if scoreStart < 0:
        return u""
        
    scoreEnd = section.find("</div>", scoreStart)
    if scoreEnd < 0:
        return u""
        
    return section[scoreStart + len("<div class=\"criticscore\">"):scoreEnd]


  def extract_critic_information(self, section, anchor):
    startLocation = section.find(anchor)
    if startLocation < 0:
        return u""
                
    endLocation = section.find("</span>", startLocation)
    if endLocation < 0:
        return u""
        
    result = section[(startLocation + len(anchor)):endLocation]
    result = result.replace("&amp;", "&")
    
    return result;


  def extract_author(self, section):
    return self.extract_critic_information(section, "<span class=\"criticname\">")


  def extract_source(self, section):
    return self.extract_critic_information(section, "<span class=\"publication\">")


  def extract_link(self, section):
    startLocation = section.find("<a href=\"")
    if startLocation < 0:
        return u""
        
    quoteLocation = section.find("\"", startLocation + len("<a href=\""))
    if quoteLocation < 0:
        return u""
        
    address = section[(startLocation + len("<a href=\"")):quoteLocation]
    return address


  def extract_text(self, section):
    startLocation = section.find("<div class=\"quote\">")
    if startLocation < 0:
        return None
        
    endLocation = section.find("<br>", startLocation)
    if endLocation < 0:
        return None
    
    result = section[(startLocation + len("<div class=\"quote\">")):endLocation].strip()
        
    return result
    
    
  def replace_lines(self, string):
    string = string.replace("\r\n", " ")
    string = string.replace("\r", " ")
    string = string.replace("\n", " ")
    string = string.replace("\t", " ")
    return string

    
  def extract_review_sections(self, content):
    sections = content.split("<div class=\"scoreandreview\">")    
    return sections[1:]
