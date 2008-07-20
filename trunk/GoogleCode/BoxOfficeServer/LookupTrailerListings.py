#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime

from xml.dom.minidom import getDOMImplementation, parseString

from Movie import Movie
from Person import Person 
from Location import Location
from MovieListings import MovieListings
from TrailerListings import TrailerListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupTrailerListingsHandler(webapp.RequestHandler):
  def get(self):
#    memcache.flush_all()    
    listings = self.get_listings_from_cache()
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(listings.data)
    

  def too_old(self, listings):
    now = datetime.datetime.now()
    delta = now - listings.saveDate

    return delta.seconds >= (3600 * 8)
    

  def get_listings_from_cache(self):
    listings = memcache.get("TrailerListings")

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_datastore()
      memcache.Client().set("TrailerListings", listings)

    return listings
    

  def get_listings_from_datastore(self):
    listings = TrailerListings.get_by_key_name("TrailerListings")

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice()

    return listings


  def get_listings_from_webservice(self):
    url = "http://www.apple.com/trailers/home/xml/widgets/indexall.xml"
    content = urlfetch.fetch(url).content
    encoded = unicode(content, "utf8")

    listings = TrailerListings.get_or_insert("TrailerListings")
    listings.data = encoded
    listings.put()

    return listings
