from google.appengine.ext import db
from google.appengine.ext import search

class TrailerListings(db.Model):
    data = db.TextProperty()
    saveDate = db.DateTimeProperty(auto_now=True)

