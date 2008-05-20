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
  def decodePost(self):
    global personQuery
    personQuery = Person.gql("WHERE firstName = :1 AND lastName = :2", "", "")
    global movieQuery
    movieQuery = Movie.gql("WHERE name = :1 AND year = :2", "", 2000)
    firstLine = True

    person = None
    movies = []

    for line in self.request.body_file:
      line = line.rstrip('\n')
      if line:
        if firstLine:
          firstLine = False
          (personFirstName, sep, personLastName) = line.partition("|#|")
          personFirstName = unicode(personFirstName, "utf-8")
          personLastName = unicode(personLastName, "utf-8")
          personQuery.bind(personFirstName, personLastName)
          person = personQuery.get()
          if person is None:
            person = Person(firstName = personFirstName, lastName = personLastName)
            person.put()
        else:
          (movieName, sep, movieYear) = line.partition("|#|")
          movieName = unicode(movieName, "utf-8")
          movieQuery.bind(movieName, int(movieYear))
          movie = movieQuery.get()
          if movie is None:
            movie = Movie(name = movieName, year = int(movieYear))
            movie.put()

          movies.append(movie)

    return (person, movies)
