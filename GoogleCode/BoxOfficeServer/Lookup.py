#!/usr/bin/env python

import wsgiref.handlers
from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 

from google.appengine.ext import webapp
from google.appengine.ext import db

class LookupHandler(webapp.RequestHandler):
  @classmethod
  def encodePerson(cls, person, document):
    personElement = document.createElement("person")
    personElement.setAttribute("firstName", person.firstName)
    personElement.setAttribute("lastName", person.lastName)
    personElement.setAttribute("id", str(person.key()))

    return personElement

  @classmethod
  def encodeMovie(cls, movie, document):
    movieElement = document.createElement("movie")
    movieElement.setAttribute("name", movie.name)
    movieElement.setAttribute("year", str(movie.year))
    movieElement.setAttribute("id", str(movie.key()))

    return movieElement
