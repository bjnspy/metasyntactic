#!/usr/bin/env python

import wsgiref.handlers
import LookupLocation
import LookupMovieListings
import LookupMovieReviews
import LookupPosterListings
import LookupTheaterListings
import LookupTrailerListings
import LookupUpcomingListings
import CacheStatistics
import DeleteLocation

from google.appengine.ext import webapp

class MainHandler(webapp.RequestHandler):
  def get(self):
    self.response.out.write('Hello world')

def main():
  application = webapp.WSGIApplication([
      ('/DeleteLocation', DeleteLocation.DeleteLocationHandler),
      ('/LookupLocation', LookupLocation.LookupLocationHandler),
      ('/LookupMovieListings', LookupMovieListings.LookupMovieListingsHandler),
      ('/LookupMovieReviews', LookupMovieReviews.LookupMovieReviewsHandler),
      ('/LookupPosterListings', LookupPosterListings.LookupPosterListingsHandler),
      ('/LookupTheaterListings', LookupTheaterListings.LookupTheaterListingsHandler),
      ('/LookupTrailerListings', LookupTrailerListings.LookupTrailerListingsHandler),
      ('/LookupUpcomingListings', LookupUpcomingListings.LookupUpcomingListingsHandler),
      ('/CacheStatistics', CacheStatistics.CacheStatisticsHandler)
      ],
      debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
