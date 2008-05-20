#!/usr/bin/env python

import wsgiref.handlers
import Movie

from google.appengine.ext import webapp
from google.appengine.ext import db

class DeleteAllMoviesHandler(webapp.RequestHandler):
  def get(self):
    q = db.GqlQuery("SELECT * FROM Movie")
#    db.delete(q.fetch(2))
#    db.delete(q.fetch(512))
    for movie in q.fetch(128):
      movie.delete()

    self.response.out.write("")

