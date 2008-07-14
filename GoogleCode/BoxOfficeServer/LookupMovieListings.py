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

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupMovieListingsHandler(webapp.RequestHandler):
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
    listings = memcache.get("MovieListings")

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_datastore()
      memcache.Client().set("MovieListings", listings)

    return listings
    

  def get_listings_from_datastore(self):
    listings = MovieListings.get_by_key_name("MovieListings")

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice()

    return listings


  def get_listings_from_webservice(self):
    url = "http://i.rottentomatoes.com/syndication/tab/complete_movies.txt"
    content = urlfetch.fetch(url).content
    encoded = unicode(content, "iso-8859-1")

    listings = MovieListings.get_or_insert("MovieListings")
    listings.data = encoded
    listings.put()

    return listings
