from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import CacheStatistics
import DeleteLocation
import LookupMovieReviews2
import LookupTheaterListings2
import LookupLocation
import LookupMovieListings
import LookupMovieRatings
import LookupMovieReviews
import LookupIMDbListings
import LookupNumbersListings
import LookupPosterListings
import LookupTheaterListings
import LookupTrailerListings
import LookupUpcomingListings

import import_fixer
import_fixer.FixImports('apphosting.api', 'onebox.showtimes.rpc', 'net.proto')

from google3.onebox.showtimes.rpc import showtimes_onebox_service_pb

application = webapp.WSGIApplication([
    ('/LookupMovieReviews2', LookupMovieReviews2.LookupMovieReviews2Handler),
    ('/LookupTheaterListings2', LookupTheaterListings2.LookupTheaterListings2Handler),
    ('/CacheStatistics', CacheStatistics.CacheStatisticsHandler),
    ('/DeleteLocation', DeleteLocation.DeleteLocationHandler),
    ('/LookupLocation', LookupLocation.LookupLocationHandler),
    ('/LookupIMDbListings', LookupIMDbListings.LookupIMDbListingsHandler),
    ('/LookupMovieListings', LookupMovieListings.LookupMovieListingsHandler),
    ('/LookupMovieRatings', LookupMovieRatings.LookupMovieRatingsHandler),
    ('/LookupMovieReviews', LookupMovieReviews.LookupMovieReviewsHandler),
    ('/LookupNumbersListings', LookupNumbersListings.LookupNumbersListingsHandler),
    ('/LookupPosterListings', LookupPosterListings.LookupPosterListingsHandler),
    ('/LookupTheaterListings', LookupTheaterListings.LookupTheaterListingsHandler),
    ('/LookupTrailerListings', LookupTrailerListings.LookupTrailerListingsHandler),
    ('/LookupUpcomingListings', LookupUpcomingListings.LookupUpcomingListingsHandler),
    ],
    debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()
