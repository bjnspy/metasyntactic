#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import json

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TrailerListings import TrailerListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupUpcomingListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()    
    q = self.request.get("q")
    hash = self.request.get("hash")
    studio = self.request.get("studio")
    name = self.request.get("name")

    response = None
    if q == "index":
      response = self.get_index_from_cache(hash)
    else:
      response = self.get_listings_from_cache(hash, studio, name)

    if response is None:
      response = ""

    self.response.out.write(response)


  def get_cache_times(self):
    return (8 * 60 * 60, 2 * 60 * 60)


  def get_index_keys(self):
    key = "UpcomingListings_Index"
    hash_key = key + "_Hash"
    return (key, hash_key)


  def get_listings_keys(self, studio, title):
    key = "UpcomingListings_" + studio + "_" + title
    hash_key = key + "_Hash"
    return (key, hash_key)


  def get_index_hash_from_cache(self):
    (key, hash_key) = self.get_index_keys()

    hash = memcache.get(hash_key)
    if hash is None:
      self.get_index_from_cache("false")
      hash = memcache.get(hash_key)

    return hash


  def get_index_from_cache(self, h):
    if h == "true":
      return self.get_index_hash_from_cache()

    (key, hash_key) = self.get_index_keys()
    (cache_time, hash_cache_time) = self.get_cache_times()

    listings = memcache.get(key)

    if listings is None:
      listings = self.get_index_from_site()
      memcache.Client().set(key, listings, cache_time)
      memcache.Client().set(hash_key, str(hash(listings)), hash_cache_time)

    if memcache.get(hash_key) is None:
      memcache.Client().set(hash_key, str(hash(listings)), hash_cache_time)

    return listings
    

  def get_listings_from_cache(self, h, studio, name):
    (key, hash_key) = self.get_listings_keys(studio, name)
    (cache_time, hash_cache_time) = self.get_cache_times()

    listings = memcache.get(key)

    if listings is None:
      listings = self.get_listings_from_site(studio, name)
      memcache.Client().set(key, listings, cache_time)

    return listings


  def get_listings_from_site(self, studio, name):
    url = "http://www.apple.com/moviesxml/s/" + studio + "/" + name + "/index.xml"
    content = urlfetch.fetch(url).content

    if content.find("Apple - Page Not Found") >= 0:
      return ""

    document = parseString(content)
    elements = document.getElementsByTagName("TextView")

    if len(elements) < 3:
      return ""

    elements = elements[2].getElementsByTagName("SetFontStyle")
    if len(elements) < 1:
      return ""

    if elements[0].firstChild is None:
      return ""

    return elements[0].firstChild.data.strip()


  def get_index_from_site(self):
    url = "http://www.apple.com/trailers/home/feeds/studios.json"
    content = urlfetch.fetch(url).content

    object = json.read(content)

    document = getDOMImplementation().createDocument(None, "result", None)

    resultElement = document.documentElement

    parts = None
    for entity in object:
      location = entity["location"]
      parts = location.split("/")
      if len(parts) < 4:
        continue

      if (not entity.has_key("releasedate") or 
          not entity.has_key("title")):
        continue

      movieElement = document.createElement("movie")
      resultElement.appendChild(movieElement)

      movieElement.setAttribute("studioKey", parts[2])
      movieElement.setAttribute("titleKey", parts[3])
      movieElement.setAttribute("title", entity["title"])
      movieElement.setAttribute("date", entity["releasedate"])

      if entity.has_key("poster"):
        movieElement.setAttribute("poster", entity["poster"])

      if entity.has_key("studio"):
        movieElement.setAttribute("studio", entity["studio"])

      if entity.has_key("rating"):
        rating = entity["rating"]
        if rating != "Not yet rated":
          movieElement.setAttribute("rating", rating)

      if entity.has_key("genre"):
        genresElement = document.createElement("genres")
        movieElement.appendChild(genresElement)

        for genre in entity["genre"]:
          if genre is None:
            continue
          genreElement = document.createElement("genre")
          genresElement.appendChild(genreElement)
          genreElement.setAttribute("value", genre)

      if entity.has_key("actors"):
        actorsElement = document.createElement("actors")
        movieElement.appendChild(actorsElement)

        for actor in entity["actors"]:
          if actor is None:
            continue
          actorElement = document.createElement("actor")
          actorsElement.appendChild(actorElement)
          actorElement.setAttribute("value", self.removeEncodings(actor))

      if entity.has_key("director"):
        directorsElement = document.createElement("directors")
        movieElement.appendChild(directorsElement)

        for director in entity["director"].split(", "):
          directorElement = document.createElement("director")
          directorsElement.appendChild(directorElement)
          directorElement.setAttribute("value", self.removeEncodings(director))

    return resultElement.toxml()


  def removeEncodings(self, string):
    while string.find("&#x") >= 0:
      startIndex = string.find("&#x")
      endIndex = string.find(";", startIndex)
      if endIndex == -1:
        break

      extracted = string[startIndex+3:endIndex]
      value = unichr(long(extracted, 16))
      string = string[0:startIndex] + value + string[endIndex + 1:]

    return string
