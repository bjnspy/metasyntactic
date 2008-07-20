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

class LookupMovieHandler(LookupHandler):
  def get(self):
    memcache.flush_all()    
    q = self.request.get("q")
    listings = self.get_listings_from_cache(q)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings))


  def get_listings_from_cache(self, q):
    listings = memcache.get("Movie_" + q)

    if listings is None:
      listings = self.get_listings_from_webservice(q)
      memcache.Client().set("Movie_" + q, listings, time=3*24*60*60)

    return listings
    
    
  def encodeCharacter(self, c, document):
    element = document.createElement("character")
    element.setAttribute("name", c['name'])
    if c.getID():
        element.setAttribute("id", c.getID())
    return element
    
  def encodePerson(self, p, document):
    element = document.createElement("person")
    element.setAttribute("name", p['long imdb canonical name'])
    element.setAttribute("id", p.getID())
    if p.currentRole:
        if isinstance(p.currentRole, list):
            for r in p.currentRole:
                element.appendChild(self.encodeCharacter(r, document))
        else:
            element.appendChild(self.encodeCharacter(p.currentRole, document))
            
    return element

  def encodePeople(self, movie, key, name, document, parent):
    if movie.has_key(key):
        element = document.createElement(name)
        parent.appendChild(element)
        for p in movie[key]:
            if isinstance(p, imdb.Person.Person):
                element.appendChild(self.encodePerson(p, document))


  def get_listings_from_webservice(self, q):    
    i = imdb.IMDb(accessSystem='http')
    #movie = i.get_movie(q, info=imdb.Movie.Movie.default_info + ('trivia', 'goofs', 'quotes', 'crazy credits'))
    movie = i.get_movie(q, info=imdb.Movie.Movie.default_info)
    
#    self.response.out.write(movie.keys())
#    self.response.out.write(unicode(movie.summary(), "utf8"))
    
    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement
        
    self.encodePeople(movie, 'producer', "producers", document, resultElement)
    self.encodePeople(movie, 'writer', "writers", document, resultElement)
    self.encodePeople(movie, 'director', "directors", document, resultElement)
    self.encodePeople(movie, 'original music', "music", document, resultElement)
    self.encodePeople(movie, 'cast', "cast", document, resultElement)
            
    if movie.has_key('cover url'):
        element = document.createElement("imageUrl")
        element.setAttribute("value", movie['cover url'])
        resultElement.appendChild(element)
    
    if movie.has_key('genres'):
        element = document.createElement("genres")
        resultElement.appendChild(element)
        for g in movie['genres']:
            genreElement = document.createElement("genre")
            genreElement.setAttribute("value", g)
            element.appendChild(genreElement)
        
    if movie.has_key('plot outline'):
        element = document.createElement("outline")
        element.setAttribute("value", movie['plot outline'])
        resultElement.appendChild(element)
        
    if movie.has_key('plot') and (len(movie['plot']) > 0):
        element = document.createElement("plot")
        element.setAttribute("value", movie['plot'][0])
        resultElement.appendChild(element)
        
    if movie.has_key('votes'):
        element = document.createElement("votes")
        element.setAttribute("value", str(movie['votes']))
        resultElement.appendChild(element)
        
    if movie.has_key('rating'):
        element = document.createElement("rating")
        element.setAttribute("value", str(movie['rating']))
        resultElement.appendChild(element)
        
    return zlib.compress(document.toxml("utf-8"))