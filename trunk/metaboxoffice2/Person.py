from google.appengine.ext import db
from google.appengine.ext import search

class Person(search.SearchableModel):
    firstName = db.StringProperty()
    middleNames = db.StringListProperty()
    lastName = db.StringProperty()

    def __eq__(self, other):
        return self.firstName == other.firstName and self.lastName == other.lastName

    def __hash__(self):
        return self.firstName.hash() | self.lastName.hash()

    def __cmp__(self, other):
        val = cmp(self.firstName, other.firstName)
        if val != 0:
            return val;

        return cmp(self.lastName, other.lastName)

    def __repr__(self):
        return "<Person firstName=\"" + self.firstName + "\" lastName=\"" + self.lastName + "\"/>"

    def __str__(self):
        return __repr__(self)
