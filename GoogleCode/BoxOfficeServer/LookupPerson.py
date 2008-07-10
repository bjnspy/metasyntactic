#!/usr/bin/env python

import wsgiref.handlers
from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db

class LookupPersonHandler(LookupHandler):
  def get(self):
    id = self.request.get("id")

    person = Person.get(id)
    if person is None:
      self.response.out.write("")
      return

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    personElement = self.encodePerson(person, document)
    resultElement.appendChild(personElement)

    directorElement = document.createElement("director")
    resultElement.appendChild(directorElement)

    writerElement = document.createElement("writer")
    resultElement.appendChild(writerElement)

    castElement = document.createElement("cast")
    resultElement.appendChild(castElement)

    for movie in Movie.gql("WHERE directors = :1", person.key()).order('-year').order('name'):
      directorElement.appendChild(self.encodeMovie(movie, document))

    for movie in Movie.gql("WHERE writers = :1", person.key()).order('-year').order('name'):
      writerElement.appendChild(self.encodeMovie(movie, document))

    for movie in Movie.gql("WHERE cast = :1", person.key()).order('-year').order('name'):
      castElement.appendChild(self.encodeMovie(movie, document))

    self.response.out.write(document.toxml())
