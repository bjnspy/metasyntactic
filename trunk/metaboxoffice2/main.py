#!/usr/bin/env python

import wsgiref.handlers
import UploadMovie
import UploadCastMember
import UploadDirector
import UploadWriter
import DeleteAllMovies
import DeleteAllUsers
import Search
import LookupPerson
import LookupMovie
import LookupLocation
import LookupMovieListings
import LookupTheaterListings

from google.appengine.ext import webapp

class MainHandler(webapp.RequestHandler):
  def get(self):
    self.response.out.write('Hello world!?!')

def main():
  application = webapp.WSGIApplication([('/', MainHandler),
                                        ('/UploadMovie', UploadMovie.UploadMovieHandler),
                                        ('/DeleteAllMovies', DeleteAllMovies.DeleteAllMoviesHandler),
                                        ('/DeleteAllUsers', DeleteAllUsers.DeleteAllUsersHandler),
                                        ('/UploadCastMember', UploadCastMember.UploadCastMemberHandler),
                                        ('/UploadDirector', UploadDirector.UploadDirectorHandler),
                                        ('/UploadWriter', UploadWriter.UploadWriterHandler),
                                        ('/Search', Search.SearchHandler),
                                        ('/LookupMovie', LookupMovie.LookupMovieHandler),
                                        ('/LookupPerson', LookupPerson.LookupPersonHandler),
                                        ('/LookupLocation', LookupLocation.LookupLocationHandler),
                                        ('/LookupMovieListings', LookupMovieListings.LookupMovieListingsHandler),
                                        ('/LookupTheaterListings', LookupTheaterListings.LookupTheaterListingsHandler)],
                                       debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
