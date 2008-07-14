#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import random

from Movie import Movie
from Person import Person 
from Location import Location

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class CacheStatisticsHandler(webapp.RequestHandler):
  def get(self):
    stats = memcache.Client().get_stats()
    out = self.response.out
    out.write(str(stats))
    return
    out.write("Cache hits     : " + str(stats["hits"]));
    out.write("Cache missed   : " + str(stats["misses"]));
    out.write("Byte hits      : " + str(stats["byte_hits"]));
    out.write("Items          : " + str(stats["items"]));
    out.write("Bytes          : " + str(stats["items"]));
    out.write("Oldest item age: " + str(stats["oldest_item_age"]));

  
