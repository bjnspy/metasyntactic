#!/usr/bin/env python

import wsgiref.handlers
import logging
import urllib
import datetime
import zlib
import random
import LookupRottenTomatoesReviews

from xml.dom.minidom import getDOMImplementation, parseString

from Location import Location
from MovieListings import MovieListings
from TheaterListings import TheaterListings

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch

class LookupMovieTicketsTheaterListingsHandler:
  def get_theater_info(self, text):
    theaterEnd = text.find("</a> </li>")
    if theaterEnd < 0:
      return None

    theaterStart = text.rfind(">", 0, theaterEnd)
    if theaterStart < 0:
      return None

    idStart = text.rfind("=", 0, theaterStart)
    if idStart < 0:
      return None

    idEnd = text.find('"', idStart)
    if idEnd < 0:
      return None

    fullName = text[theaterStart+1:theaterEnd]
    dashIndex = fullName.rfind(" - ")
    if dashIndex > 0:
      fullName = fullName[0:dashIndex]

    return (fullName, text[idStart+1:idEnd])

  def get_theater_list_from_site(self, q, date):
    url = "http://www.movietickets.com/house_list.asp?SearchZip=" + q + "&SearchRange=40"
    theatersPage = urlfetch.fetch(url).content
    start = theatersPage.find("frmHouseListMap")
    if start < 0:
      return None

    end = theatersPage.find("</ul>", start)
    if end < 0:
      return None

    result = []
    items = theatersPage[start:end].split("<li")
    for item in items[1:]:
      theaterInfo = self.get_theater_info(item)
      if not theaterInfo is None:
        result.append(theaterInfo)

    return result


  def get_theater_list_from_cache(self, q, date):
    key = "MovieTicketsTheaterList_" + q
    theaterList = memcache.get(key)

    if theaterList is None:
      theaterList = self.get_theater_list_from_site(q, date)
      memcache.Client().set(key, theaterList, 4 * 60 * 60)

    return theaterList


  def get_listings(self, q, date):
    theaterList = self.get_theater_list_from_cache(q, date)
    if theaterList is None:
      return None

    result = ""

    for theater in theaterList:
      result += theater[0] + "\t" + theater[1] + "\n"

    listings = TheaterListings()
    listings.data = zlib.compress(result)
    listings.saveDate = datetime.datetime.now()

    return listings

  def get_movies_and_showtimes_for_theater_from_site(self, q, date, theater):
    url = "http://www.movietickets.com/house_detail.asp?house_id=" + theater[1] + "&rdate=" + date
    showtimesPage = urlfetch.fetch(url).content

    movieSections = showtimesPage.split('href="movie_detail.asp?movie_id')
    return len(movieSections)


  def get_movies_and_showtimes_for_theater_from_cache(self, q, date, theater):
    key = "MovieTicketsMoviesAndShowtimesList_" + q + "_" + date + "_" + theater[1]
    movieAndShowtimes = memcache.get(key)

    if movieAndShowtimes is None:
      movieAndShowtimes = self.get_movies_and_showtimes_for_theater_from_site(q, date, theater)
      memcache.Client().set(key, movieAndShowtimes, 4 * 60 * 60)

    return movieAndShowtimes


  def get_showtimes_list_from_site(self, q, date, theaterList):
    result = []

    for theater in theaterList:
      moviesAndShowtimes = self.get_movies_and_showtimes_for_theater_from_cache(q, date, theater)
      if not moviesAndShowtimes is None:
        result.append((theater, moviesAndShowtimes))

    return result;


  def get_showtimes_list_from_cache(self, q, date, theaterList):
    key = "MovieTicketsShowtimesList_" + q + "_" + date
    showtimesList = memcache.get(key)

    if showtimesList is None:
      showtimesList = self.get_showtimes_list_from_site(q, date, theaterList)
      memcache.Client().set(key, showtimesList, 4 * 60 * 60)

    return showtimesList
