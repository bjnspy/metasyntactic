#!/usr/bin/env python

import wsgiref.handlers
import Location

from google.appengine.ext import webapp
from google.appengine.ext import db

class DeleteLocationHandler(webapp.RequestHandler):
  def get(self):
    q = db.GqlQuery("SELECT * FROM Location")
#    q.fetch(64).delete()
    for location in q.fetch(64):
      location.delete()

    self.response.out.write("")
