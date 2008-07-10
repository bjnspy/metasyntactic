#!/usr/bin/env python

import wsgiref.handlers
import logging

from xml.dom.minidom import getDOMImplementation

from Movie import Movie
from Person import Person 
from Zipcode import Zipcode
from Lookup import LookupHandler

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupZipcodeHandler(webapp.RequestHandler):
  def get(self):
    z = self.request.get("q")

    zipcode = self.get_zipcode_from_cache(z)
    if zipcode is None:
      self.response.out.write("")
      return

    document = getDOMImplementation().createDocument(None, "result", None)
    
    resultElement = document.documentElement
    resultElement.setAttribute("latitude", zipcode.latitude)
    resultElement.setAttribute("longitude", zipcode.longitude)
    resultElement.setAttribute("city", zipcode.city)
    resultElement.setAttribute("state", zipcode.state)

    self.response.out.write(document.toxml())


  def get_zipcode_from_cache(self, z):
    zipcode = None
#    zipcode = memcache.get(z)
    if zipcode is None:
      zipcode = self.get_zipcode_from_datastore(z)
      memcache.add(z, zipcode)

    return zipcode
    

  def get_zipcode_from_datastore(self, z):
    q = Zipcode.gql("WHERE value = :1", z)
    zipcode = q.fetch(1)
    if zipcode is None:
      zipcode = self.get_zipcode_from_webservice(z)
      zipcode.put()

    return zipcode


  def get_zipcode_from_webservice(self, z):
    key = "TVq1wv_V34E9W2rK45TyIi1nj1BcnTpf2D00jo6zc4_HyqgVpu8QHRfaGLsbRja4RVO25sb_"
    url = "http://local.yahooapis.com/MapsService/V1/geocode?appid=" + key + "&location=" + z
    content = urlfetch.fetch(url).content
    logging.error(content)
    return None

    
    
    
