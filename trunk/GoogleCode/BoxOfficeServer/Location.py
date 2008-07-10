from google.appengine.ext import db
from google.appengine.ext import search

class Location(db.Model):
    latitude = db.FloatProperty()
    longitude = db.FloatProperty()
    address = db.StringProperty()
    city = db.StringProperty()
    state = db.StringProperty()
    zipcode = db.StringProperty()
    country = db.StringProperty()
