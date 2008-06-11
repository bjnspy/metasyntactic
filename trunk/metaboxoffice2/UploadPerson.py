#!/usr/bin/env python

import wsgiref.handlers
from Movie import Movie
from Person import Person
import logging

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.ext import db
from google.appengine.api import memcache

import xml.dom.minidom
from xml.dom.minidom import Node

class UploadPersonHandler(webapp.RequestHandler):
  def makeKey(self, line):
    return '_' + unicode(line, "utf-8")

  def decodePost(self):
    firstLine = True

    person = None
    movies = []
    roles = []

    for line in self.request.body_file:
      line = line.rstrip('\n')
      if line:
        if firstLine:
          firstLine = False
          (personFirstName, sep, personLastName) = line.partition("\t")
          personFirstName = unicode(personFirstName, "utf-8")
          personLastName = unicode(personLastName, "utf-8")
          person = Person.get_or_insert(self.makeKey(line), firstName = personFirstName, lastName = personLastName)
        else:
          list = line.split("\t")
          key = self.makeKey(list[0] + "\t" + list[1])
          movieName = unicode(list[0], "utf-8")
          movieYear = int(list[1])

          movie = Movie.get_or_insert(key, name = movieName, year = movieYear)
          role = unicode(list[2], "utf-8")

          movies.append(movie)
          roles.append(role)

    return (person, movies, roles)
