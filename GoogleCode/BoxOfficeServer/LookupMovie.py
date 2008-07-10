#!/usr/bin/env python

import wsgiref.handlers
from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db

class LookupMovieHandler(LookupHandler):
  def get(self):
    id = self.request.get("id")

    movie = Movie.get(id)
    if movie is None:
      self.response.out.write("")
      return

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    movieElement = self.encodeMovie(movie, document)
    resultElement.appendChild(movieElement)

    directorsElement = document.createElement("directors")
    resultElement.appendChild(directorsElement)

    writersElement = document.createElement("writers")
    resultElement.appendChild(writersElement)

    castElement = document.createElement("cast")
    resultElement.appendChild(castElement)

    people = []
    for key in movie.directors:
      person = Person.get(key)
      if not person is None:
        people.append(person)

    for person in people.sort():
      directorsElement.appendChild(self.encodePerson(person, document))

    people = []
    for key in movie.writers:
      person = Person.get(key)
      if not person is None:
        people.append(person)

    for person in people.sort():
      writersElement.appendChild(self.encodePerson(person, document))

    people = []
    for key in movie.cast:
      person = Person.get(key)
      if not person is None:
        people.append(person)

    for person in people.sort():
      castElement.appendChild(self.encodePerson(person, document))

    self.response.out.write(document.toxml())
