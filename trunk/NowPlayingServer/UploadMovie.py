#!/usr/bin/env python

import wsgiref.handlers
import Movie

from google.appengine.ext import webapp
from google.appengine.ext import db

class UploadMovieHandler(webapp.RequestHandler):
  def get(self):
    name = self.request.get("name") 
    year = self.request.get("year")
    q = db.GqlQuery('SELECT * FROM Movie WHERE name = :1 AND year = :2', name, year)
    if q.count(1) == 0:
      movie = Movie.Movie()
      movie.name = name
      movie.year = year
      movie.put()

    self.response.out.write("")
