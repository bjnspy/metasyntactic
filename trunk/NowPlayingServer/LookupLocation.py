#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import random

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupLocationHandler(webapp.RequestHandler):
  def get(self):
    q = self.request.get("q")

#    memcache.flush_all()

    location = self.get_location_from_cache(urllib.quote(q))
    if location is None:
      self.response.out.write("")
      return

    document = getDOMImplementation().createDocument(None, "result", None)

    resultElement = document.documentElement
    resultElement.setAttribute("latitude", str(location.latitude))
    resultElement.setAttribute("longitude", str(location.longitude))
    resultElement.setAttribute("address", location.address)
    resultElement.setAttribute("city", location.city)
    resultElement.setAttribute("state", location.state)
    resultElement.setAttribute("zipcode", location.zipcode)
    resultElement.setAttribute("country", location.country)

    self.response.out.write(document.toxml())


  def get_location_from_cache(self, q):
    location = memcache.get(q)

    if location is None:
      location = self.get_location_from_datastore(q)
      memcache.Client().set(q, location)

    return location
    

  def get_location_from_datastore(self, q):
    location = Location.get_by_key_name("_" + q)

    if location is None:
      location = self.get_location_from_webservice(q)

    return location

  def get_value(self, element, name):
    nodes = element.getElementsByTagName(name)[0].childNodes
    if len(nodes) > 0:
      return nodes[0].nodeValue
    
    return ""

  def get_location_from_webservice(self, q):
    keys = [ "TVq1wv_V34E9W2rK45TyIi1nj1BcnTpf2D00jo6zc4_HyqgVpu8QHRfaGLsbRja4RVO25sb_", "JTVP_y3V34H93_TVoJpPPS.yd37hCbVj2kbRW5BdY4pu0ueVrk6.r6BWhOfaP1SHjrF8hWk-", "1" ] 
    index = random.randint(0, len(keys) - 1)
    key = keys[index]

    url = "http://local.yahooapis.com/MapsService/V1/geocode?appid=" + key + "&location=" + q
    content = urlfetch.fetch(url).content

    document = parseString(content)
    root = document.documentElement

    if root.tagName != "ResultSet":
      return None

    resultElement = root.getElementsByTagName("Result")[0]
    if resultElement.tagName != "Result":
      return None

    latitude = self.get_value(resultElement, "Latitude")
    longitude = self.get_value(resultElement, "Longitude")
    address = self.get_value(resultElement, "Address")
    city = self.get_value(resultElement, "City")
    state = self.get_value(resultElement, "State")
    zip = self.get_value(resultElement, "Zip")
    country = self.get_value(resultElement, "Country")

    return Location.get_or_insert("_" + q,
                                  latitude = float(latitude),
                                  longitude = float(longitude),
                                  address = address,
                                  city = city,
                                  state = state,
                                  zipcode = zip,                 
                                  country = country)
  
