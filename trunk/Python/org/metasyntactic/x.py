#!/usr/bin/env python

from xml.etree import ElementTree

class Serializer:
    def to_string(self, v):
        return str(v)
 
    def attribute_key_to_string(self, k):
        return self.to_string(k)

    def attribute_value_to_string(self, v):
        return self.to_string(v)

class X:
    @staticmethod
    def to_string(e, serializer=Serializer()):
        return ElementTree.tostring(X.to_element(e, serializer), encoding="UTF-8")

    @staticmethod
    def to_element(e, serializer=Serializer()):
        return e.to_element(serializer)

class N:
    def __init__(self):
        self.__parent = None
        self.__next = None
        self.__previous = None

    def parent(self):
        return self.__parent

    def next(self):
        return self.__next

    def previous(self):
        return self.__previous

    # only subclasses can set these values.  they are not public so that
    # no one external can break our invariants.  If people outside of
    # this module access these setters then all bets are off
    def _set_parent(self, parent):
        self.__parent = parent
        
    def _set_next(self, next):
        self.__next = next
    
    def _set_previous(self, previous):
        self.__previous = previous


class T(N):
    def __init__(self, text):
        N.__init__(self);
        if isinstance(text, unicode):
            self.__text = text
        elif isinstance(text, str):
            self.__text = unicode(text)
        else:
            raise Exception()

    def text(self):
        return self.__text
    
    def _clone(self):
        return T(self.__text)


class E(N):
    def __init__(self, tag, *remainder):
        N.__init__(self);
        self.__tag = tag
        self.__children = []
        self.__attributes = {}
        self.append(remainder)

    def _clone(self):
        return E(self.__tag, self.__attributes, map(lambda n: n._clone(), self.__children))

    def tag(self):
        return self.__tag

    def iterattributes(self):
        return self.__attributes.iteritems()

    def iternodes(self):
        # easier way to do this?  i want to expose the stream of children, but
        # not let anyone modify it.
        for c in self.__children:
            yield c
    
    def iterelements(self):
        return filter(lambda n: isinstance(n, E), self.iternodes())

    def itertext(self):
        return map(lambda t: t.text, filter(lambda n: isinstance(n, T), self.iternodes()))

    def text(self):
        "".join(self.itertext())
    
    def append(self, child):
        if child is None:
            return

        if isinstance(child, N):
            self.__attach(child)
        elif isinstance(child, dict):
            self.__attributes.update(child.iteritems())
        elif isinstance(child, unicode) or isinstance(child, str):
            self.append(T(child))
        elif hasattr(child,'__iter__'):
            for grand_child in child:
                self.append(grand_child)
        else:
            raise Exception()


    def __swap(self, old_child, new_child):
        index = self.__children.index(old_child)
        self.__children.remove(old_child)
        self.__children.insert(index, new_child)

        # first attach the new child to this parent and stitch in into the list
        #of siblings
        new_child._set_parent(self)
        new_child._set_next(old_child.next())
        new_child._set_previous(old_child.previous())

        if new_child.next() is not None:
            new_child.next()._set_previous(new_child)
        
        if new_child.previous() is not None:
            new_child.previous()._set_next(new_child)

        # Now, totally disconnect the old child
        old_child._set_parent(None)
        old_child._set_next(None)
        old_child._set_previous(None)


    def __attach(self, child):
        if child.parent() is not None:
            # complicated case. this child belongs to another tree.  clone it
            # and jam the clone into the other tree.  then put this child into
            # this tree
            clone = child._clone()
            child.parent().__swap(child, clone)
            
        # child is now unowned.  just stitch it in.
        previous = None if len(self.__children) == 0 else self.__children[-1]
        self.__children.append(child)

        child._set_parent(self)
        child._set_next(None)
        child._set_previous(previous)
        if previous is not None:
            previous._set_next(child)
    

    def to_element(self, serializer):
        a = dict((serializer.attribute_key_to_string(k),
                  serializer.attribute_value_to_string(v))
                 for (k,v) in self.__attributes.items())
        e = ElementTree.Element(self.tag(), a)
        e.text = ""
        e.tail = ""

        # text nodes belong to the last element child we've encountered.
        # if we haven't seen any element children yet, then then text node
        # belongs to this element.
        i = 0
        length = len(self.__children)
        last_child = None
        while i < length:
            c = self.__children[i]
            if isinstance(c, T):
                if last_child is None:
                    e.text += c.text()
                else:
                    last_child.tail += c.text()
            else:
                last_child = c.to_element(serializer)
                e.append(last_child)
            i = i + 1
        
        return e