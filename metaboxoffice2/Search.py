#!/usr/bin/env python

import wsgiref.handlers

from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db

class SearchHandler(LookupHandler):
  def get(self):
    q = self.request.get("q")

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement
    moviesElement = document.createElement("movies")
    peopleElement = document.createElement("people")
    resultElement.appendChild(moviesElement)
    resultElement.appendChild(peopleElement)
    
    for person in Person.all().search(q).order('lastName').order('firstName'):
      peopleElement.appendChild(LookupHandler.encodePerson(person, document))

    for movie in Movie.all().search(q).order('-year').order('name'):
      moviesElement.appendChild(LookupHandler.encodeMovie(movie, document))

    self.response.out.write(document.toxml())
