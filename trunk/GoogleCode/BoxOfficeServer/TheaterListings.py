from google.appengine.ext import db
from google.appengine.ext import search

class TheaterListings(db.Model):
    data = db.BlobProperty()
    saveDate = db.DateTimeProperty(auto_now=True)

