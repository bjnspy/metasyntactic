#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random

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

class LookupTheaterListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()
    q = self.request.get("q")
    listings = self.get_listings_from_cache(q)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings.data))
    

  def too_old(self, listings):
    now = datetime.datetime.now()
    delta = now - listings.saveDate

    return delta.seconds >= (3600 * 8)
    

  def get_listings_from_cache(self, q):
    listings = memcache.get("TheaterListings_" + q)

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice(q)
      memcache.Client().set("TheaterListings_" + q, listings)

    return listings
    

  def get_listings_from_datastore(self, q):
    listings = TheaterListings.get_by_key_name("_" + q)

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice(q)

    return listings


  def get_listings_from_webservice(self, q):
    keys = [ "A99D3D1A-774C-49149E", "DE7E251E-7758-40A4-98E0-87557E9F31F0"]
    index = random.randint(0, len(keys) - 1)
    key = keys[index]

    url = "http://www.fandango.com/frdi/?pid=" + key + "&op=performancesbypostalcodesearch&verbosity=1&postalcode=" + q
    logging.info("Url: " + url)
    content = urlfetch.fetch(url).content

    listings = TheaterListings()
    listings.data = zlib.compress(content)
    listings.saveDate = datetime.datetime.now()

    return listings
