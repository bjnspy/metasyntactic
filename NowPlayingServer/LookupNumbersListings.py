#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import json
import time

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupNumbersListingsHandler(webapp.RequestHandler):
  def get(self):
    #memcache.flush_all()
    q = self.request.get("q")
    id = self.request.get("id")
    hash = self.request.get("hash")

    response = None
    if q == "index":
      response = self.get_index_from_cache(hash)
    else:
      response = self.get_numbers_from_cache(hash, id)

    if response is None:
      response = ""

    self.response.out.write(response)


  def get_index_from_cache(self, h):
    key = "NumbersListings_Index"
    listings = memcache.get(key)

    if listings is None:
      listings = self.get_index_from_site()
      memcache.Client().set(key, listings, 8 * 60 * 60)

    return listings
    

  def get_numbers_from_cache(self, hash, id):
    key = "NumbersListings_" + id
    listings = memcache.get(key)

    if listings is None:
      listings = self.get_numbers_from_site(id)
      memcache.Client().set(key, listings, 8 * 60 * 60)

    return listings


  def get_numbers_from_site(self, name):
    url = "http://access.opusdata.com/session/create?email=cyrus.najmabadi@gmail.com&password=b3t@t3st"
    content = urlfetch.fetch(url).content

    object = json.read(content)
    
    if not object.has_key("session_id") or not object.has_key("server"):
      return None

    session_id = object["session_id"]
    server = object["server"]
  
    url = "http://" + server + "/movie_theatrical_chart/oe" + name + "/session_id=" + session_id
    weekend = urlfetch.fetch(url).content

    url = "http://" + server + "/movie_theatrical_chart/oy" + name + "/session_id=" + session_id
    daily = urlfetch.fetch(url).content

    url = "http://" + server + "/movie/" + name + "/session_id=" + session_id
    movie = urlfetch.fetch(url).content

    urlfetch.fetch("http://access.opusdata.com/session/close/" + session_id)

    weekend_json = json.read(weekend)
    daily_json = json.read(daily)
    movie_json = json.read(movie)

    if (not weekend_json.has_key("chart_entries") or
        not daily_json.has_key("chart_entries")):
      return None

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement
    if movie_json.has_key("production_cost"):
      resultElement.setAttribute("budget", movie_json["production_cost"])

    weekendElement = document.createElement("weekend")
    dailyElement = document.createElement("daily")
    resultElement.appendChild(weekendElement)
    resultElement.appendChild(dailyElement)

    if len(weekend_json["chart_entries"]) >= 2:
      for entry in weekend_json["chart_entries"][-2:]:
        movie_element = self.convert_to_xml(document, entry)
        weekendElement.appendChild(movie_element)
      
    if len(daily_json["chart_entries"]) >= 2:
      for entry in daily_json["chart_entries"][-2:]:
        movie_element = self.convert_to_xml(document, entry)
        dailyElement.appendChild(movie_element)

    return document.toxml()


  def get_index_from_site(self):
    url = "http://access.opusdata.com/session/create?email=cyrus.najmabadi@gmail.com&password=b3t@t3st"
    content = urlfetch.fetch(url).content

    object = json.read(content)
    
    if not object.has_key("session_id") or not object.has_key("server"):
      return None

    session_id = object["session_id"]
    server = object["server"]
  
    url = "http://" + server + "/movie_theatrical_chart/we99999999/session_id=" + session_id
    weekend = urlfetch.fetch(url).content

    url = "http://" + server + "/movie_theatrical_chart/da99999999/session_id=" + session_id
    daily = urlfetch.fetch(url).content

    urlfetch.fetch("http://access.opusdata.com/session/close/" + session_id)

    weekend_json = json.read(weekend)
    daily_json = json.read(daily)

    if not weekend_json.has_key("chart_entries") or not daily_json.has_key("chart_entries"):
      return None

    document = getDOMImplementation().createDocument(None, "result", None)
    resultElement = document.documentElement

    weekendElement = document.createElement("weekend")
    dailyElement = document.createElement("daily")
    resultElement.appendChild(weekendElement)
    resultElement.appendChild(dailyElement)

    for entry in weekend_json["chart_entries"]:
      movie_element = self.convert_to_xml(document, entry)
      weekendElement.appendChild(movie_element)
      
    for entry in daily_json["chart_entries"]:
      movie_element = self.convert_to_xml(document, entry)
      dailyElement.appendChild(movie_element)

    return document.toxml()


  def convert_to_xml(self, document, entry):
    movie = document.createElement("movie")
    movie.setAttribute("id", entry["movie_odid"])
    movie.setAttribute("title", entry["display_name"])
    movie.setAttribute("current_rank", entry["rank"])
    movie.setAttribute("previous_rank", entry["previous_rank"])
    movie.setAttribute("revenue", entry["revenue"])
    movie.setAttribute("total_revenue", entry["total_revenue"])
    movie.setAttribute("theaters", entry["theater_count"])
    movie.setAttribute("days", entry["days_in_release"])
    return movie
