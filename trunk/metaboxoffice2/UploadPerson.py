#!/usr/bin/env python

import wsgiref.handlers
from Movie import Movie
from Person import Person
import logging

from google.appengine.ext import webapp
from google.appengine.ext import db

import xml.dom.minidom
from xml.dom.minidom import Node
from google.appengine.ext import db

class UploadPersonHandler(webapp.RequestHandler):
  def makeKey(self, line):
    return '_' + unicode(line, "utf-8")

  def decodePost(self):
    firstLine = True

    person = None
    movies = []

    for line in self.request.body_file:
      line = line.rstrip('\n')
      logging.info(line)
      if line:
        if firstLine:
          firstLine = False
          (personFirstName, sep, personLastName) = line.partition("\t")
          personFirstName = unicode(personFirstName, "utf-8")
          personLastName = unicode(personLastName, "utf-8")
          person = Person.get_or_insert(self.makeKey(line), firstName = personFirstName, lastName = personLastName)
        else:
          (movieName, sep, movieYear) = line.partition("\t")
          movieName = unicode(movieName, "utf-8")
          movie = Movie.get_or_insert(self.makeKey(line), name = movieName, year = int(movieYear))
          movies.append(movie)

    return (person, movies)
