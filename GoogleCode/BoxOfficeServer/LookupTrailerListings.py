#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import json

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TrailerListings import TrailerListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupTrailerListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()    
    q = self.request.get("q")
    studio = self.request.get("studio")
    name = self.request.get("name")

    response = None
    if q == "index":
      response = self.get_index_from_cache()
    else:
      response = self.get_trailers_from_cache(studio, name)

    if response is None:
      response = ""

    self.response.out.write(response)


  def get_index_from_cache(self):
    listings = memcache.get("TrailerListings_Index")

    if listings is None:
      listings = self.get_index_from_site()
      memcache.Client().set("TrailerListings_Index", listings, 8 * 60 * 60)

    return listings
    

  def get_trailers_from_cache(self, studio, name):
    key = "TrailerListings_" + studio + "_" + name
    listings = memcache.get(key)

    if listings is None:
      listings = self.get_trailers_from_site(studio, name)
      memcache.Client().set(key, listings, 8 * 60 * 60)

    return listings


  def get_trailers_from_site(self, studio, name):
    url = "http://www.apple.com/moviesxml/s/" + studio + "/" + name + "/index.xml"
    content = urlfetch.fetch(url).content

    if content.find("Apple - Page Not Found") >= 0:
      return ""

    document = parseString(content)
    elements = document.getElementsByTagName("string")

    result = ""
    for element in elements:
      text = element.firstChild
      if not text is None and text.data.endswith(".m4v"):
        if len(result) > 0:
          result += "\n"
        result += text.data

    return result


  def get_index_from_site(self):
    url = "http://www.apple.com/trailers/home/feeds/studios.json"
    content = urlfetch.fetch(url).content

    object = json.read(content)

    result = ""
    for entity in object:
      title = entity["title"].replace("\t", " ").strip()
      location = entity["location"].replace("\t", " ").strip()
      parts = location.split("/")
      if len(parts) >= 4:
        if len(result) > 0:
          result += "\n"
        result += title + "\t" + parts[2] + "\t" + parts[3]

    return result
