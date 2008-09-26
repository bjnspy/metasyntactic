#!/usr/bin/env python

import wsgiref.handlers

from google.appengine.api import memcache
from google.appengine.ext import webapp

class CacheStatisticsHandler(webapp.RequestHandler):
  def get(self):
    stats = memcache.Client().get_stats()
    self.response.out.write(str(stats))
    return
