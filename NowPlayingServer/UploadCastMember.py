#!/usr/bin/env python

import wsgiref.handlers
import Movie
from UploadPerson import UploadPersonHandler

from google.appengine.ext import webapp
from google.appengine.ext import db

class UploadCastMemberHandler(UploadPersonHandler):
  def post(self):
    (person, movies, roles) = UploadPersonHandler.decodePost(self)
    
    for i in range(len(movies)):
      movie = movies[i]
      role = roles[i]
      if not person.key() in movie.cast:
        movie.cast.append(person.key())
        movie.characters.append(role)
        movie.put()

    self.response.out.write('')
