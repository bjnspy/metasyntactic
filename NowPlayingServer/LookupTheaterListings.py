#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupMovieTicketsTheaterListings

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupTheaterListingsHandler(webapp.RequestHandler):
  def out_of_date(self):
    self.response.out.write('''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><performancesbypostalcodesearchresponse><data>
<theaters totalcount="3" pagenum="1" itemcount="3">
<theater id="10" tmsid="" purchaseid="" tz="" dst="" iswired="False"><name>This version is out of date</name><address1></address1><city></city><state></state><postalcode></postalcode><phonenumber></phonenumber><movies totalcount="3"><movie id="1"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="2"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="3"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie></movies></theater>

<theater id="20" tmsid="" purchaseid="" tz="" dst="" iswired="False"><name>Please upgrade</name><address1></address1><city></city><state></state><postalcode></postalcode><phonenumber></phonenumber><movies totalcount="3"><movie id="1"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="2"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="3"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie></movies></theater>

<theater id="30" tmsid="" purchaseid="" tz="" dst="" iswired="False"><name>Check the Appstore for updates</name><address1></address1><city></city><state></state><postalcode></postalcode><phonenumber></phonenumber><movies totalcount="3"><movie id="1"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="2"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie><movie id="3"><performances totalcount="1"><performance showdate="9/14/2008" showtime="12:00 PM" showid="100" /></performances></movie></movies></theater>
</theaters>

<movies totalcount="3">
<movie id="1" tmsid="" posterhref=""><title>This version is out of date</title><rating>NR</rating><runtime>0</runtime><synopsis type="short"><![CDATA[This version of BoxOffice/NowPlaying is out of date.  Please update to the latest version by using iTunes or the iPhone appstore.]]></synopsis></movie>

<movie id="2" tmsid="" posterhref=""><title>Please upgrade</title><rating>NR</rating><runtime>0</runtime><synopsis type="short"><![CDATA[This version of BoxOffice/NowPlaying is out of date.  Please update to the latest version by using iTunes or the iPhone appstore.]]></synopsis></movie>

<movie id="3" tmsid="" posterhref=""><title>Check the appstore for updates</title><rating>NR</rating><runtime>0</runtime><synopsis type="short"><![CDATA[This version of BoxOffice/NowPlaying is out of date.  Please update to the latest version by using iTunes or the iPhone appstore.]]></synopsis></movie>
</movies></data></performancesbypostalcodesearchresponse>''')

    return

  def get(self):
#    self.out_of_date()
#    return

#    memcache.flush_all()
    q = self.request.get("q")
    date = self.request.get("date")
    provider = self.request.get("provider")

    if provider != "Fandango" and provider != "MovieTickets":
      provider = "Fandango"

    listings = self.get_listings_from_cache(q, date, provider)
    if listings is None:
      self.response.out.write("")
      return

    self.response.out.write(zlib.decompress(listings.data))
    

  def too_old(self, listings):
    now = datetime.datetime.now()
    delta = now - listings.saveDate

    return delta.seconds >= (3600 * 8)
    

  def get_listings_from_cache(self, q, date, provider):
    key = "TheaterListings_" + q + "_" + date + "_" + provider;
    listings = memcache.get(key)

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice(q, date, provider)
      memcache.Client().set(key, listings)

    return listings
    

  def get_listings_from_datastore(self, q):
    listings = TheaterListings.get_by_key_name("_" + q)

    if listings is None or self.too_old(listings):
      listings = self.get_listings_from_webservice(q)

    return listings


  def get_listings_from_webservice(self, q, date, provider):
    if provider == "Fandango":
      return self.get_listings_from_fandango(q, date)

    if provider == "MovieTickets":
      return self.get_listings_from_movietickets(q, date)

    return None


  def get_listings_from_movietickets(self, q, date):
    return LookupMovieTicketsTheaterListings.LookupMovieTicketsTheaterListingsHandler().get_listings(q, date)


  def get_listings_from_fandango(self, q, date):
    keys = [ "A99D3D1A-774C-49149E", "DE7E251E-7758-40A4-98E0-87557E9F31F0"]
    index = random.randint(0, len(keys) - 1)
    key = keys[index]

    url = "http://www.fandango.com/frdi/?pid=" + key + "&op=performancesbypostalcodesearch&verbosity=1&postalcode=" + q
    if not date is None and date != "":
      url = url + "&date=" + date

    logging.info("Url: " + url)
    content = urlfetch.fetch(url).content

    listings = TheaterListings()
    listings.data = zlib.compress(content)
    listings.saveDate = datetime.datetime.now()

    return listings
