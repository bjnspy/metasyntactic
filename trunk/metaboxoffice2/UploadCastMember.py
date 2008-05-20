#!/usr/bin/env python

import wsgiref.handlers
import Movie
from UploadPerson import UploadPersonHandler

from google.appengine.ext import webapp
from google.appengine.ext import db

class UploadCastMemberHandler(UploadPersonHandler):
  def post(self):
    (person, movies) = UploadPersonHandler.decodePost(self)
    
    for movie in movies:
      if not person.key() in movie.cast:
        movie.cast.append(person.key())
        movie.put()

    self.response.out.write('')
