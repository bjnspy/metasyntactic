#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import random

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupIMDbListingsHandler(webapp.RequestHandler):
  def get(self):
    q = self.request.get("q")

    #memcache.flush_all()

    location = self.get_listings_from_cache(urllib.quote(q))
    if location is None:
      self.response.out.write("")
      return

    self.response.out.write(location)


  def get_listings_from_cache(self, q):
    key = "IMDbListing_" + q
    location = memcache.get(key)

    if location is None:
      location = self.get_listings_from_webservice(q)
      memcache.Client().set(key, location)

    return location


  def get_value(self, element, name):
    nodes = element.getElementsByTagName(name)[0].childNodes
    if len(nodes) > 0:
      return nodes[0].nodeValue
    
    return ""
    

  def get_listings_from_webservice(self, q):
    keys = [ "TVq1wv_V34E9W2rK45TyIi1nj1BcnTpf2D00jo6zc4_HyqgVpu8QHRfaGLsbRja4RVO25sb_", "JTVP_y3V34H93_TVoJpPPS.yd37hCbVj2kbRW5BdY4pu0ueVrk6.r6BWhOfaP1SHjrF8hWk-" ] 
    index = random.randint(0, len(keys) - 1)
    key = keys[index]

    url = "http://search.yahooapis.com/WebSearchService/V1/webSearch?appid=" + key + "&query=" + q + "&results=1&site=www.imdb.com" 
    content = urlfetch.fetch(url).content

    document = parseString(content)
    root = document.documentElement

    if root.tagName != "ResultSet":
      return None

    elements = root.getElementsByTagName("Result")
    if elements is None or len(elements) == 0:
      return None

    resultElement = elements[0]
    if resultElement.tagName != "Result":
      return None

    url = self.get_value(resultElement, "Url")
    return url
  
