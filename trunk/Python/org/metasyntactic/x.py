#!/usr/bin/env python

""" Classes to declaratively generate and process XML.

This module provides a way to for clients to declaratively produce XML in
a manner missing in most python XML libraries.  It aims to be very lightweight,
while also providing a very simple, terse and pythonic method for producing
xml.

Unlike the standard dom/minidom, this module understands, consumes and exposes
standard python collections.  Unlike ElementTree, this module exposes a
declarative (rather than procedural) api for XML construction.  For example,
using both facilities you can now do the following:

    e = XE.Students(
            XE.Person({ "name":p.first_name, "age":p.age })
            for p in students if is_awesome(p))
    x = str(e)

After this, x will be:
          <Students>
              <Person name="Cyrus" age="27"/>
              <Person .../>
              ...
          </Students>

As you can see, the library aims to provide an interface that lets you produce
code that matches the XML you want very closely.  (Indeed, if you squint just
right and swap some python punctuation for XML punctuation, they're almost the
same).

The library understands python types, translating dictionaries to attributes,
and iterable objects to children.  Furthermore, it is lenient with the objects
it accepts.  There is no need to convert all your values into strings in order
to use this library.  Instead, this will be taken care of for you
automatically.  By default, any value provided will be converted to a string
for the XML by calling str(value).  However, you can customize this conversion
by providing your own instance of the Serializer class when calling to_string.
"""

import xml as xml
import xml.dom as xmldom
import xml.dom.minidom as minidom

class Serializer(object):
    """
    This class allows for specialized serialization when emitting the final XML
    code for an XML Document/Element.  For example, if a user specified the
    attributes for an XElement as { "age" : 21 } then this class would let them
    define the serializer of integers so that it was emitted as: age="0x15"
    By default, this class converts all values to strings using the 'str'
    function.
    """
    def to_string(self, v):
        return str(v)
    
    def object_to_string(self, v):
        """
        Used to convert the values of X.object nodes into strings.  Override
        this if you want to specialize that behavior.  By default, just defers
        to Serializer.to_string
        """
        return self.to_string(v)
 
    def attribute_key_to_string(self, k):
        return self.to_string(k)

    def attribute_value_to_string(self, v):
        return self.to_string(v)

    def _convert(self, iteritems):
        if iteritems is None:
            return None

        return ((self.attribute_key_to_string(k),
                 self.attribute_value_to_string(v))
                for (k,v) in iteritems)


class XE:
    """
    Helper class to allow callers to easily create XElements.  Instead of
    having to say: XElement("foo", ...) you can instead say: XE.foo(...).
    This allows for a simpler, more declarative, and closer to XML syntax
    for your code
    """
    class XEMetaClass(type):
        def __getattr__(self, name):
            # trap any calls to methods we don't know about (like 'foo') in the
            # above example.  Return a continuation that will take any
            # remainder arguments and pass it along to the actual XElement
            # constructor
            return lambda *remainder: _Element(name, remainder)

    __metaclass__ = XEMetaClass


class X(object):
    """
    Utility class to allow easy creation of different types of XML nodes.
    Callers can use either a full form or a trimmed form depending on the
    desire for clarity vs. brevity.
    
    i.e. you can say:
        X.element("foo", X.comment("This is a comment i want in my XML))
        
    or they can say:
    
        X.e("foo", X.c("This is a comment i want in my XML"))
    
    This allows the content to not be drowned out by the XML construction code.
    Care should be taken though.  If too many different XML node types are used
    then the intent can easily be lost.
    """
    @classmethod
    def comment(cls, text):
        """ Returns a comment node equivalent to: <!--text--> """
        return _Comment(text)

    @classmethod
    def c(cls, text):
        """ Shorthand form of as X.comment """
        return X.comment(text)

    @classmethod
    def document(cls, root, *remainder):
        """
        Creates an XML document out of a root XML element and any
        additional elements (i.e. comments, processing instructions,
        document type).
        """
        return _Document(root, remainder)
    
    @classmethod
    def d(cls, root, *remainder):
        """ Shorthand form of as X.document """
        return X.document(root, remainder)

    @classmethod
    def document_type(cls, public_id=u"", system_id=u"", internal_subset=u"",
                      name=u"",entities=None, notations=None):
        """
        Creates an XML document type declaration such as:
        <!DOCTYPE greeting SYSTEM "hello.dtd">
        """
        return _DocumentType(public_id, system_id, internal_subset,
                             name, entities, notations)

    @classmethod
    def dt(cls, public_id=u"", system_id=u"", internal_subset=u"",
           name=u"",entities=None, notations=None):
        """ Shorthand form of as X.dt """
        return X.document_type(public_id, system_id, internal_subset,
                               name, entities, notations)

    @classmethod
    def element(cls, tag, *remainder):
        """
        Creates an XML element.  The tag of the element (i.e. the text
        directly following the open backet) is the only required element.  All
        additional features are provided in the 'remainder' list.  This list
        will be decomposed and the constituent elements will become part of
        the resultant element.  The decomposition strategy is as follows:
          * Any nodes in the list will become child nodes of the element.
          * Any dictionaries found will become the attributes of this element
            (with a last one wins strategy in the case of matching keys).
          * Anything iterable will be iterated over with the current strategy
            applied to all individual elements
          * Any strings will become text node children of this element
          * Anything else will become object node children of this element
        """
        return _Element(tag, remainder)

    @classmethod
    def e(cls, tag, *remainder):
        """ Shorthand form of as X.e """
        return X.element(tag, remainder)

    @classmethod
    def object(cls, value):
        """
        Enacapsulates a python value so it can be stored in an XML document.
        Serialization of this value will be handled by the Serializer
        passed into the to_string method.
        """
        return _Object(value)

    @classmethod
    def o(cls, value):
        """ Shorthand form of as X.object """
        return X.object(value)

    @classmethod
    def processing_instruction(cls, target, text=u""):
        """
        Creates an XML processing instruction of the form:
        <?target text?>
        """
        return _ProcessingInstruction(target, text)
    
    @classmethod
    def pi(cls, target, text=u""):
        """ Shorthand form of as X.pi """
        return X.processing_instruction(target, text)
    
    @classmethod
    def text(cls, text):
        """ Creates a normal XML text node. """
        return _Text(text)
    
    @classmethod
    def t(cls, text):
        """ Shorthand form of as X.text """
        return X.text(text)
    
    @classmethod
    def parse(cls, text):
        """
        Parses the provided text and will return a corresponding XML document
        with all the elements contained within.
        """
        document = minidom.parseString(text)
        return X.from_dom(document)

    @classmethod
    def from_dom(cls, dom):
        """
        Creates the appropriate XML element given a specified python
        dom/minidom node.  The type of the node must be one of the following:
            ELEMENT_NODE
            TEXT_NODE
            PROCESSING_INSTRUCTION_NODE
            COMMENT_NODE
            DOCUMENT_NODE
            DOCUMENT_TYPE_NODE
        """
        if (dom.nodeType == xmldom.Node.ELEMENT_NODE):
            return _Element._from_dom(dom)

        if dom.nodeType == xmldom.Node.TEXT_NODE:
            return _Text._from_dom(dom)

        if dom.nodeType == xmldom.Node.PROCESSING_INSTRUCTION_NODE:
            return _ProcessingInstruction._from_dom(dom)

        if dom.nodeType == xmldom.Node.COMMENT_NODE:
            return _Comment._from_dom(dom)

        if dom.nodeType == xmldom.Node.DOCUMENT_NODE:
            return _Document._from_dom(dom)

        if dom.nodeType == xmldom.Node.DOCUMENT_TYPE_NODE:
            return _DocumentType._from_dom(dom)
        
        raise Exception("Unknown dom type")
    
    @classmethod
    def _convert_named_node_map(cls, nnm):
        """
        Helper method to convert from a dom/minidom NamedNodeMap type into a
        normal python dictionary.
        """
        d = {}
        if not nnm is None:
            for i in range(nnm.length):
                attr = nnm.item(i)
                d[attr.name] = attr.value
        return d
    
    @classmethod
    def _convert_node_list(cls, nl):
        """
        Helper method to convert from a dom/minidom NodeList type into a normal
        python list
        """
        l = []
        if not nl is None:
            for i in range(nl.length):
                n = nl.item(i)
                l.append(X.from_dom(n))
        return l

class _Node(object):
    """
    Root of the XML node hierarchy.  This class generically handles the concept
    of parent/child/next/previous for all nodes.  It also deals with the case
    where you have an existing node in a tree and you want to add it to a new
    tree.  In that case, the node will be cloned and spliced out of its old
    tree appropriately.
    """
    def __init__(self):
        self.__children = None
        self.__parent = None
        self.__next = None
        self.__previous = None

    def parent(self):
        return self.__parent

    def next(self):
        return self.__next

    def previous(self):
        return self.__previous

    def _append(self, child):
        if child is None:
            return

        if isinstance(child, _Node):
            # Simple case.  We already have an XML node.  Just add it to our
            # child list
            self.__attach(child)
        elif isinstance(child, unicode) or isinstance(child, str):
            # If its a string of some sort, then add a text node
            self._append(X.text(child))
        elif hasattr(child,'__iter__'):
            # enumerate all the items in the iterable, then add each one
            # individually
            for grand_child in child:
                self._append(grand_child)
        else:
            # Otherwise, add it as an object
            self._append(X.object(child))

    def __swap(self, old_child, new_child):
        """ Replaces an existing child node of ours with a new child """
        index = self.__children.index(old_child)
        self.__children.remove(old_child)
        self.__children.insert(index, new_child)

        # first attach the new child to this parent and stitch in into the list
        #of siblings
        new_child.__parent = self
        new_child.__next = old_child.__next
        new_child.__previous = old_child.__previous

        if new_child.__next is not None:
            new_child.__next.__previous = new_child
        
        if new_child.__previous is not None:
            new_child.__previous.__next = new_child

        # Now, totally disconnect the old child
        old_child.__parent = None
        old_child.__next = None
        old_child.__previous = None

    def __attach(self, child):
        if child.__parent is not None:
            # complicated case. this child belongs to another tree.  clone it
            # and jam the clone into the other tree.  then put this child into
            # this tree
            clone = child._clone()
            child.__parent.__swap(child, clone)

        # child is now unowned.  just stitch it in.
        previous = None if not self.__children else self.__children[-1]
        
        if self.__children is None:
            self.__children = []

        self.__children.append(child)

        child.__parent = self
        child.__next = None
        child.__previous = previous
        if previous is not None:
            previous.__next = child

    def iternodes(self):
        """
        Allows interation over the children of this node.  In order to ensure
        invariants, the child list is not directly exposed.  Instead, only
        an iterable view over it is available
        """
        if self.__children is None:
            return []

        return (c for c in self.__children)
    
    def iterelements(self):
        """
        Returns all the element children of this node, skipping all others
        """
        return (c for c in self.iternodes() if isinstance(c, XElement));

    def itertext(self):
        """
        Returns all the text children of this node, skipping all others
        """
        return (c.text for c in self.iternodes() if isinstance(n, XText))

    def text(self):
        """ Returns all the text joined together into one string """
        "".join(self.itertext())


class _Comment(_Node):
    """ An XML comment """
    def __init__(self, text):
        _Node.__init__(self);
        self.__text = unicode(text)

    def text(self):
        return self.__text
    
    def _clone(self):
        return X.comment(self.__text)

    def __repr__(self):
        return "X.comment(" + repr(self.__text) + ")"

    def _to_dom_worker(self, dom, document, serializer):
        return document.createComment(self.__text)

    @classmethod
    def _from_dom(cls, dom):
        return X.comment(dom.data)


class _Document(_Node):
    """ An XML document """
    def __init__(self, root, *remainder):
        _Node.__init__(self)
        self.__root = root
        self._append(root)
        self._append(remainder)
    
    def __iternodes_without_root(self):
        return (n for n in self.iternodes() if n != self.__root)
    
    def _clone(self):
        return X.document(self.__root._clone(),
                          (n._clone() for n in self.__iternodes_without_root()))
    
    def __repr__(self):
        args = [repr(self.__root)]

        children = list(self.__iternodes_without_root())
        if len(children) > 0:
            args.append(repr(children))

        return "X.document(" + ", ".join(args) + ")"

    def to_dom(self, serializer):
        # Dom is slightly messed up.  When creating a document we need to
        # supply the root element name.  However, in order to create our root
        # element, we need the document created first.  This prevents us from
        # a nice recursive solution to creating a document.  So, instead, we
        # create the document, using the tag name for our root element.  We
        # then tell our actual root element to add its children to the root
        # element that was created in the minidom document.  Yuck
        dom = minidom.getDOMImplementation()
        document = dom.createDocument(None, self.__root.tag(), None)
        
        for n in self.__iternodes_without_root():
            document.appendChild(n._to_dom_worker(dom, document, serializer))

        self.__root._append_to_dom_element(document.documentElement, dom,
                                           document, serializer)

        return document

    def to_string(self, serializer=Serializer()):
        return self.to_dom(serializer).toxml("utf-8")

    @classmethod
    def _from_dom(cls, dom):
        return X.document(X.from_dom(dom.documentElement),
                          X._convert_node_list(dom.childNodes))


class _DocumentType(_Node):
    """ An XML document type """
    def __init__(self, public_id=u"", system_id=u"", internal_subset=u"",
                 name=u"",entities=None, notations=None):
        _Node.__init__(self)
        self.__public_id = unicode(public_id)
        self.__system_id = unicode(system_id)
        self.__internal_subset = unicode(internal_subset)
        self.__name = unicode(name)
        self.__entities = entities;
        self.__notations = notations;
    
    def _clone(self):
        return X.document_type(self.__public_id, self.__system_id,
                               self.__internal_subset, self.__name,
                               self.__entities, self.__notations)

    def __repr__(self):
        return ("X.document_type(" +
                ", ".join((repr(self.__public_id), repr(self.__system_id),
                           repr(self.__internal_subset), repr(self.__name),
                           repr(self.__entities), repr(self.__notations))) + ")")

    def _to_dom_worker(self, dom, document, serializer):
        dt = dom_implementation.createDocumentType(self.__name,
                                                   self.__public_id,
                                                   self.__system_id)
        dt.entities = serializer._convert(self.__entities)
        dt.notations = serializer._convert(self.__notations)

        return dt

    @classmethod
    def _from_dom(cls, dom):
        return X.document_type(public_id=dom.publicId,
                               system_id=dom.systemId,
                               iternal_subset=dom.internalSubset,
                               name=dom.name,
                               entities=X._convert_named_node_map(
                                dom.entities),
                               notations=X._convert_named_node_map(
                                dom.notations))


class _Element(_Node):
    """ An XML element """
    def __init__(self, tag, *remainder):
        _Node.__init__(self);
        self.__tag = unicode(tag)
        self.__attributes = None
        self.__append(remainder)

    def _clone(self):
        return X.element(self.__tag, self.__attributes,
                         (n._clone() for n in self.iternodes()))

    def tag(self):
        return self.__tag

    def iterattributes(self):
        if self.__attributes is None:
            return {}

        return self.__attributes.iteritems()
    
    def __append(self, child):
        if child is None:
            return

        if isinstance(child, dict):
            if self.__attributes is None:
                self.__attributes = {}

            self.__attributes.update(child.iteritems())
        else:
            # defer to superclass to handle this
            self._append(child)

    def to_dom(self, serializer=Serializer()):
        dom = minidom.getDOMImplementation()
        document = dom.createDocument(None, self.__tag, None)
        self._append_to_dom_element(document.documentElement, dom, document,
                                    serializer)
        return document

    def _append_to_dom_element(self, element, dom, document, serializer):
        for n in self.iternodes():
            element.appendChild(n._to_dom_worker(dom, document, serializer))

        for (k,v) in serializer._convert(self.iterattributes()):
            element.setAttribute(k,v)

    def _to_dom_worker(self, dom, document, serializer):
        element = document.createElement(self.__tag)
        self._append_to_dom_element(element, dom, document, serializer)
        return element

    def to_string(self, serializer=Serializer()):
        return self.to_dom(serializer).toxml("utf-8")

    def __repr__(self):
        args = [repr(self.__tag)]
        if self.__attributes:
            args.append(repr(self.__attributes))

        children = list(self.iternodes())
        if children:
            args.append(repr(children))

        return "X.element(" + ", ".join(args) + ")"

    def __str__(self):
        return self.to_string()

    @classmethod
    def _from_dom(cls, dom):
        return X.element(dom.tagName,
                         X._convert_named_node_map(dom.attributes),
                         X._convert_node_list(dom.childNodes))


class _Object(_Node):
    """ An XML object node (for storing arbitrary python objects """
    def __init__(self, value):
        _Node.__init__(self);
        self.__value = value

    def value(self):
        return self.__value
    
    def _clone(self):
        return X.object(self.__value)

    def __repr__(self):
        return "X.object(" + repr(self.__value) + ")"

    def _to_dom_worker(self, dom, document, serializer):
        return document.createTextNode(serializer.to_string(self.__value))


class _ProcessingInstruction(_Node):
    """ An XML processing instruction element """
    def __init__(self, target, text=u""):
        _Node.__init__(self)
        self.__target = unicode(target)
        self.__text = unicode(text)

    def target(self):
        return self.__target
    
    def text(self):
        return self.__text
    
    def _clone(self):
        return X.processing_instruction(self.__target, self.__text)

    def __repr__(self):
        return ("X.processing_instruction(" +
                ", ".join((repr(self.__target), repr(self.__text))) + ")")

    def _to_dom_worker(self, dom, document, serializer):
        return document.createProcessingInstruction(self.__target, self.__text)
    
    @classmethod
    def _from_dom(cls, dom):
        return X.processing_instruction(dom.target, dom.data)


class _Text(_Node):
    """ An XML text node """
    def __init__(self, text):
        _Node.__init__(self);
        self.__text = unicode(text)

    def text(self):
        return self.__text
    
    def _clone(self):
        return X.text(self.__text)

    def __repr__(self):
        return "X.text(" + repr(self.__text) + ")"

    def _to_dom_worker(self, dom, document, serializer):
        return document.createTextNode(self.__text)
    
    @classmethod
    def _from_dom(cls, dom):
        return X.text(dom.data)