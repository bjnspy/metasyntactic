from google.appengine.ext import db
from google.appengine.ext import search

class MovieListings(db.Model):
    data = db.TextProperty()
    saveDate = db.DateTimeProperty(auto_now=True)

