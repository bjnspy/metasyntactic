from google.appengine.ext import db
from google.appengine.ext import search

class Movie(search.SearchableModel):
    name = db.StringProperty()
    year = db.IntegerProperty()
    directors = db.ListProperty(db.Key)
    writers = db.ListProperty(db.Key)

    cast = db.ListProperty(db.Key)
    characters = db.StringListProperty()

    def __eq__(self, other):
        return self.name == other.name and self.year == other.year


    def __hash__(self):
        return self.name.hash() | self.year.hash()

    
    def __cmp__(self, other):
        val = cmp(self.year, other.year)
        if val != 0:
            return -val

        return cmp(self.name, other.name)

    
    def __repr__(self):
        return "<Movie name=\"" + self.name + "\" year=\"" + self.year + "\"/>"


    def __str__(self):
        return __repr__(self)
