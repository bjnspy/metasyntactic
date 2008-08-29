from google.appengine.ext import db
from google.appengine.ext import search

class Zipcode(db.Model):
    value = db.StringProperty()
    latitude = db.FloatProperty()
    longitude = db.FloatProperty()
    city = db.StringProperty()
    state = db.StringProperty()
