#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupRottenTomatoesReviews

from xml.dom.minidom import getDOMImplementation, parseString

from Movie import Movie
from Person import Person 
from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupRottenTomatoesReviewsHandler:
  def get_listings(self, content):
    sections  = self.extract_review_sections(content)
    result = ""
    for s in sections:
        review = self.extract_review(s)
        if not review is None:
            result += (review + "\n")
    
    return zlib.compress(result)
    
    
  def extract_review(self, section):
    text = self.extract_text(section)
    if text is None:
        return None
    
    positive = section.find("fresh.gif") >= 0
    score = "99" if positive else "50" 
    author = self.extract_author(section)
    source = self.extract_source(section)
    link = self.extract_link(section)
    
    text = self.replace_lines(text)
    link = self.replace_lines(link)
    author = self.replace_lines(author)
    source = self.replace_lines(source)
    
    return text + "\t" + score + "\t" + link + "\t" + author + "\t" + source


  def extract_critic_information(self, section, anchor):
    anchorLocation = section.find(anchor)
    if anchorLocation < 0:
        return ""
        
    startTag = "\">"
    startLocation = section.find(startTag, anchorLocation + len(anchor))
    if startLocation < 0:
        return ""
        
    endLocation = section.find("</a>", startLocation)
    if endLocation < 0:
        return ""
        
    result = section[(startLocation + len(startTag)):endLocation]
    result = result.replace("&amp;", "&")
    
    return result;


  def extract_author(self, section):
    return self.extract_critic_information(section, "<div class=\"author\">")


  def extract_source(self, section):
    return self.extract_critic_information(section, "<div class=\"source\">")


  def extract_link(self, section):
    fullReviewLocation = section.find("Full Review")
    if fullReviewLocation < 0:
        return ""

    hrefString = "href=\""
    startLocation = section[:fullReviewLocation].rfind("href=\"")
    if startLocation < 0:
        return ""
        
    quoteLocation = section.find("\"", startLocation + len(hrefString))
    if quoteLocation < 0:
        return ""
        
    address = section[(startLocation + len(hrefString)):quoteLocation]
    return "http://www.rottentomatoes.com" + address


  def extract_text(self, section):
    startLocation = section.find("<p>")
    if startLocation < 0:
        return None
        
    endLocation = section.find("</p>", startLocation)
    if endLocation < 0:
        return None
    
    result = section[(startLocation + 3):endLocation].strip()
    result = result.replace("<I>", "")
    result = result.replace("<i>", "")
    result = result.replace("</i>", "")

    if result.find("to read the article") >= 0:
        return None
        
    return result
    
    
  def replace_lines(self, string):
    string = string.replace("\r\n", " ")
    string = string.replace("\r", " ")
    string = string.replace("\n", " ")
    string = string.replace("\t", " ")
    return string

    
  def extract_review_sections(self, content):
    startLocation = content.find("<div id=\"Content_Reviews\"")
    if startLocation < 0:
      return []
        
    endLocation = content.find("<div class=\"main_reviews_column_nav\"", startLocation)
    if endLocation < 0:
      return []
        
    subsection = content[startLocation:endLocation]
    sections = subsection.split("quoteBubble")
    
    return sections[1:]