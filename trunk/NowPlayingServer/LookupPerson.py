#!/usr/bin/env python

import wsgiref.handlers
from xml.dom.minidom import getDOMImplementation
import zlib

from Movie import Movie
from Person import Person 
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache

import imdb

class LookupPersonHandler(LookupHandler):
  def get_test(self):
    self.response.out.write()

  def get(self):
    self.get_test()
    return
    
    memcache.flush_all()    
    q = self.request.get("id")
    listings = self.get_listings_from_cache(q)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings))


  def get_listings_from_cache(self, q):
    listings = memcache.get("Person_" + q)

    if listings is None:
      listings = self.get_listings_from_webservice(q)
      memcache.Client().set("Person_" + q, listings, time=3*24*60*60)

    return listings
    

  def get_listings_from_webservice(self, q):    
    i = imdb.IMDb(accessSystem='http')
    person = i.get_person(q, info=imdb.Person.Person.default_info)
    
    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement
       
    LookupHandler.encodeMovies(person, 'producer', 'producer', document, resultElement)
    LookupHandler.encodeMovies(person, 'director', 'director', document, resultElement)
    LookupHandler.encodeMovies(person, 'actor', 'cast', document, resultElement)
    LookupHandler.encodeMovies(person, 'actress', 'cast', document, resultElement)
    LookupHandler.encodeMovies(person, 'writer', 'writer', document, resultElement)
     
    if person.has_key('mini biography') and len(person['mini biography']) > 0:
        element = document.createElement("biography")
        element.setAttribute("value", person['mini biography'][0])
        resultElement.appendChild(element)

    if person.has_key('quotes'):
        element = document.createElement("quotes")
        resultElement.appendChild(element)
        for quote in person['quotes']:
            quoteElement = document.createElement("quote")
            quoteElement.setAttribute("value", quote)
            element.appendChild(quoteElement)
        
    if person.has_key('trivia'):
        element = document.createElement("trivia")
        resultElement.appendChild(element)
        for trivium in person['trivia']:
            triviumElement = document.createElement("trivium")
            triviumElement.setAttribute("value", trivium)
            element.appendChild(triviumElement)

    if person.has_key('headshot'):
        element = document.createElement("headshot")
        element.setAttribute("value", person['headshot'])
        resultElement.appendChild(element)
           
    if person.has_key('birth date'):
        element = document.createElement("birthDate")
        element.setAttribute("value", person['birth date'])
        resultElement.appendChild(element)
           
    if person.has_key('death date'):
        element = document.createElement("deathDate")
        element.setAttribute("value", person['death date'])
        resultElement.appendChild(element)
            
    return zlib.compress(document.toxml("utf-8"))