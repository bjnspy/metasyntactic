#!/usr/bin/env python

import wsgiref.handlers
import Movie

from google.appengine.ext import webapp
from google.appengine.ext import db

class DeleteAllUsersHandler(webapp.RequestHandler):
  def get(self):
    q = db.GqlQuery("SELECT * FROM Person")
    for result in q.fetch(16):
      result.delete()

    self.response.out.write("")

