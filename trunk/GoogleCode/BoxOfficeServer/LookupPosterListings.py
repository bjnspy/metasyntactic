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

class LookupPosterListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()    

    response = self.get_posters_from_cache()
    if response is None:
      response = ""

    self.response.out.write(response)


  def get_posters_from_cache(self):
    listings = memcache.get("PosterListings")

    if listings is None:
      listings = self.get_posters_from_site()
      memcache.Client().set("PosterListings", listings, 8 * 60 * 60)

    return listings


  def get_posters_from_site(self):
    url = "http://www.apple.com/trailers/home/feeds/studios.json"
    content = urlfetch.fetch(url).content

    object = json.read(content)

    result = ""
    for entity in object:
      title = entity["title"].replace("\t", " ").strip()
      poster = entity["poster"].replace("\t", " ").strip()

      if len(result) > 0:
        result += "\n"

      result += title + "\t" + poster

    return result
