#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupRottenTomatoesReviews
import LookupMetacriticReviews

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

class LookupMovieReviewsHandler(webapp.RequestHandler):
  def get(self):
#    memcache.flush_all()
    q = self.request.get("q")
    hash = self.request.get("hash")

    if hash == "true":
      self.get_hash(q)
      return

    listings = self.get_listings_from_cache(q)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings))


  def get_hash(self, q):
    key = "MovieReviews_" + q + "_Hash";
    hash = memcache.get(key)

    if hash is None:
      self.response.out.write("0")
    else:
      self.response.out.write(hash)


  def get_listings_from_cache(self, q):
    key = "MovieReviews_" + q
    hashKey = key + "_Hash";

    listings = memcache.get(key)

    if listings is None:
      listings = self.get_listings_from_webservice(q)
      memcache.Client().set(key, listings, 24 * 60 * 60)
      memcache.Client().set(hashKey, hash(listings))

    if memcache.get(hashKey) is None:
      memcache.Client().set(hashKey, hash(listings))

    return listings


  def get_listings_from_webservice(self, q):
    if q.find("www.rottentomatoes.com") >= 0:
        if q[-1] != "/":
            q += "/"
        q += "?critic=creamcrop"
        content = urlfetch.fetch(q).content
        return LookupRottenTomatoesReviews.LookupRottenTomatoesReviewsHandler().get_listings(content)

    if q.find("www.metacritic.com") >= 0:
        content = urlfetch.fetch(q).content
        return LookupMetacriticReviews.LookupMetacriticReviewsHandler().get_listings(content)
        
    return None
