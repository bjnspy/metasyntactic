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

from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupMovieReviewsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()
    q = self.request.get("q")
    hash = self.request.get("hash")
    format = self.request.get("format")

    if format != "tab" and format != "xml":
      format = "tab"

    if hash == "true":
      self.get_hash(q, format)
      return

    listings = self.get_listings_from_cache(q, format)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(listings)


  def get_keys(self, q, format):
    key = "MovieReviews_" + q + "_" + format
    hash_key = key + "_Hash";
    return (key, hash_key)

  def get_hash(self, q, format):
    (key, hash_key) = self.get_keys(q, format)
    hash = memcache.get(hash_key)

    if hash is None:
      self.get_listings_from_cache(q, format)
      hash = memcache.get(hash_key)

    if hash is None:
      self.response.out.write("0")
    else:
      self.response.out.write(hash)


  def get_listings_from_cache(self, q, format):
    (key, hash_key) = self.get_keys(q, format)

    listings = memcache.get(key)

    if listings is None:
      listings = self.get_listings_from_webservice(q, format)
      memcache.Client().set(key, listings, 8 * 60 * 60)
      memcache.Client().set(hash_key, str(hash(listings)), 2 * 60 * 60)

    if memcache.get(hash_key) is None:
      memcache.Client().set(hash_key, str(hash(listings)), 2 * 60 * 60)

    return listings


  def get_listings_from_webservice(self, q, format):
    if q.find("www.rottentomatoes.com") >= 0:
        if q[-1] != "/":
            q += "/"
        q += "?critic=creamcrop"
        content = urlfetch.fetch(q).content
        content = unicode(content, "iso-8859-1")
        return LookupRottenTomatoesReviews.LookupRottenTomatoesReviewsHandler().get_listings(content, format)

    if q.find("www.metacritic.com") >= 0:
        content = urlfetch.fetch(q).content
        content = unicode(content, "utf8")
        return LookupMetacriticReviews.LookupMetacriticReviewsHandler().get_listings(content, format)
        
    return None
