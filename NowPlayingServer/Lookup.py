#!/usr/bin/env python

import wsgiref.handlers
from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 

from google.appengine.ext import webapp
from google.appengine.ext import db

import imdb

class LookupHandler(webapp.RequestHandler):
  @classmethod
  def encodeCharacter(cls, c, document):
    element = document.createElement("character")
    element.setAttribute("name", c['name'])
    if c.getID():
        element.setAttribute("id", c.getID())
    return element
    
    
  @classmethod
  def encodeCharacters(cls, characters, document, parent):
    if characters:
        element = document.createElement("characters")
        parent.appendChild(element)
        
        if isinstance(characters, list):
            for c in characters:
                element.appendChild(cls.encodeCharacter(c, document))
        else:
            element.appendChild(cls.encodeCharacter(characters, document))        
        
    
  @classmethod
  def encodePerson(cls, p, document):
    element = document.createElement("person")
    element.setAttribute("name", p['long imdb canonical name'])
    element.setAttribute("id", p.getID())
    cls.encodeCharacters(p.currentRole, document, element)            
    return element


  @classmethod
  def encodePeople(cls, movie, key, name, document, parent):
    if movie.has_key(key):
        element = document.createElement(name)
        parent.appendChild(element)
        seenPeople = set()
        for p in movie[key]:
            if isinstance(p, imdb.Person.Person) and not p['long imdb canonical name'] in seenPeople:
                seenPeople.add(p['long imdb canonical name'])
                element.appendChild(cls.encodePerson(p, document))
 
  
  @classmethod
  def encodeMovie(cls, m, document):
    element = document.createElement("movie")
    element.setAttribute("name", m['canonical title'])
    element.setAttribute("id", m.getID()) 
    cls.encodeCharacters(m.currentRole, document, element)
    return element
  
      
  @classmethod
  def encodeMovies(cls, person, key, name, document, parent):
    if person.has_key(key):
        element = document.createElement(name)
        parent.appendChild(element)
        for m in person[key]:
            element.appendChild(cls.encodeMovie(m, document))
            
