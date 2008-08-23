#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupMovieTicketsTheaterListings

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupShowtimes(webapp.RequestHandler):
  def get(self):
    q = self.request.get("q")
    date = self.request.get("date")
    provider = self.request.get("provider")

    listings = self.get_listings_from_cache(q, date, provider)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings))
    

  def get_showtimes_from_cache(self, q, date, provider):
    key = "Showtimes_" + q + "_" + date + "_" + provider;
    listings = memcache.get(key)

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice(q, date, provider)
      memcache.Client().set(key, listings, 4 * 60 * 60)

    return listings
    
  def get_showtimes_from_site(self, q, date, provider):
    url = "http://www.fandango.com/frdi/?pid=" + key + "&op=performancesbypostalcodesearch&verbosity=1&postalcode=" + q
    if not date is None and date != "":
      url = url + "&date=" + date

    logging.info("Url: " + url)
    content = urlfetch.fetch(url).content

    listings = TheaterListings()
    listings.data = zlib.compress(content)
    listings.saveDate = datetime.datetime.now()

    return listings
