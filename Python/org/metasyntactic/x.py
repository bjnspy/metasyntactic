#!/usr/bin/env python

import xml as xml
import xml.dom as xmldom
import xml.dom.minidom as minidom

class Serializer:
    def to_string(self, v):
        return str(v)
 
    def attribute_key_to_string(self, k):
        return self.to_string(k)

    def attribute_value_to_string(self, v):
        return self.to_string(v)

    def convert(self, iteritems):
        return ((self.attribute_key_to_string(k), self.attribute_value_to_string(v))
                    for (k,v) in iteritems)


class XE:
    class XMetaClass(type):
        def __getattr__(self, name):
            return lambda *remainder: XElement(name, remainder)

    __metaclass__ = XMetaClass


class X:
    @classmethod
    def comment(cls, text):
        return XComment(text)

    @classmethod
    def document(cls, root, *remainder):
        return XDocument(root, remainder)

    @classmethod
    def document_type(cls, public_id=u"", system_id=u"", internal_subset=u"",
                      name=u"",entities=None, notations=None):
        return XDocumentType(public_id, system_id, internal_subset,
                             name, entities, notations)

    @classmethod
    def element(cls, tag, *remainder):
        return XElement(tag, remainder)

    @classmethod
    def processing_instruction(cls, target, text=u""):
        return XProcessingInstruction(target, text)
    
    @classmethod
    def text(cls, text):
        return XText(text)
        
    @classmethod
    def parse(cls, text):
        document = minidom.parseString(text)
        return X.from_dom(document)

    @classmethod
    def from_dom(cls, dom):
        if (dom.nodeType == xmldom.Node.ELEMENT_NODE):
            return XElement._from_dom(dom)

        if dom.nodeType == xmldom.Node.TEXT_NODE:
            return XText._from_dom(dom)

        if dom.nodeType == xmldom.Node.PROCESSING_INSTRUCTION_NODE:
            return XProcessingInstruction._from_dom(dom)

        if dom.nodeType == xmldom.Node.COMMENT_NODE:
            return XComment._from_dom(dom)

        if dom.nodeType == xmldom.Node.DOCUMENT_NODE:
            return XDocument._from_dom(dom)

        if dom.nodeType == xmldom.Node.DOCUMENT_TYPE_NODE:
            return XDocumentType._from_dom(dom)
        
        raise Exception(str(type(dom)))
    
    @classmethod
    def _convert_named_node_map(cls, nnm):
        d = {}
        if not nnm is None:
            for i in range(nnm.length):
                attr = nnm.item(i)
                d[attr.name] = attr.value
        return d
    
    @classmethod
    def _convert_node_list(cls, nl):
        l = []
        if not nl is None:
            for i in range(nl.length):
                n = nl.item(i)
                l.append(X.from_dom(n))
        return l

class XNode:
    def __init__(self):
        self.__children = []
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

        if isinstance(child, XNode):
            self.__attach(child)
        elif isinstance(child, unicode) or isinstance(child, str):
            self.append(XText(child))
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
        previous = None if len(self.__children) == 0 else self.__children[-1]
        self.__children.append(child)

        child.__parent = self
        child.__next = None
        child.__previous = previous
        if previous is not None:
            previous.__next = child

    def iternodes(self):
        return (c for c in self.__children)
    
    def iterelements(self):
        return (c for c in self.__children if isinstance(c, XElement));

    def itertext(self):
        return (c.text for c in self.__children if isinstance(n, XText))

    def text(self):
        "".join(self.itertext())


class XComment(XNode):
    def __init__(self, text):
        XNode.__init__(self);
        self.__text = unicode(text)

    def text(self):
        return self.__text
    
    def _clone(self):
        return XComment(self.__text)

    def __repr__(self):
        return self.__class__.__name__ + "(" + repr(self.__text) + ")"

    def _to_dom_worker(self, dom, document, serializer):
        return document.createComment(self.__text)

    @classmethod
    def _from_dom(cls, dom):
        return XComment(dom.data)


class XDocument(XNode):
    def __init__(self, root, *remainder):
        XNode.__init__(self)
        self.__root = root
        self.append(remainder)
    
    def _clone(self):
        return XDocument(self.__root._clone(), (n._clone() for n in self.iternodes()))
    
    def append(self, child):
        self._append(child)
    
    def __repr__(self):
        args = [repr(self.__root)]

        children = list(self.iternodes())
        if len(children) > 0:
            args.append(repr(children))

        return self.__class__.__name__ + "(" + ", ".join(args) + ")"

    def to_dom(self, serializer):
        dom = minidom.getDOMImplementation()
        document = dom.createDocument(None, self.__root.tag(), None)
        
        for n in self.iternodes():
            document.appendChild(n._to_dom_worker(dom, document, serializer))

        self.__root._append_to_dom_element(document.documentElement, dom, document, serializer)

        return document

    def to_string(self, serializer=Serializer()):
        return self.to_dom(serializer).toxml("utf-8")

    @classmethod
    def _from_dom(cls, dom):
        return XDocument(X.from_dom(dom.documentElement),
                         X._convert_node_list(dom.childNodes))


class XDocumentType(XNode):
    def __init__(self, public_id=u"", system_id=u"", internal_subset=u"",
                 name=u"",entities=None, notations=None):
        self.__public_id = unicode(public_id)
        self.__system_id = unicode(system_id)
        self.__internal_subset = unicode(internal_subset)
        self.__name = unicode(name)
        self.__entities = {} if entities is None else entities;
        self.__notations = {} if notations is None else notations;
    
    def _clone(self):
        return XDocumentType(self.__public_id, self.__system_id,
                             self.__internal_subset, self.__name,
                             self.__entities, self.__notations)

    def __repr__(self):
        return (self.__class__.__name__ + "(" +
                ", ".join((repr(self.__public_id), repr(self.__system_id),
                           repr(self.__internal_subset), repr(self.__name),
                           repr(self.__entities), repr(self.__notations))) + ")")

    def _to_dom_worker(self, dom, document, serializer):
        dt = dom_implementation.createDocumentType(self.__name,
                                                   self.__public_id,
                                                   self.__system_id)
        dt.entities = serializer.convert(self.__entities)
        dt.notations = serializer.convert(self.__notations)

        return dt

    @classmethod
    def _from_dom(cls, dom):
        return XDocumentType(public_id=dom.publicId,
                             system_id=dom.systemId,
                             iternal_subset=dom.internalSubset,
                             name=dom.name,
                             entities=X._convert_named_node_map(dom.entities),
                             notations=X._convert_named_node_map(dom.notations))


class XElement(XNode):
    def __init__(self, tag, *remainder):
        XNode.__init__(self);
        self.__tag = unicode(tag)
        self.__attributes = {}
        self.append(remainder)

    def _clone(self):
        return XElement(self.__tag, self.__attributes, (n._clone() for n in self.iternodes()))

    def tag(self):
        return self.__tag

    def iterattributes(self):
        return self.__attributes.iteritems()
    
    def append(self, child):
        if child is None:
            return

        if isinstance(child, dict):
            self.__attributes.update(child.iteritems())
        else:
            self._append(child)

    def to_dom(self, serializer=Serializer()):
        dom = minidom.getDOMImplementation()
        document = dom.createDocument(None, self.__tag, None)
        self._append_to_dom_element(document.documentElement, dom, document, serializer)
        return document

    def _append_to_dom_element(self, element, dom, document, serializer):
        for n in self.iternodes():
            element.appendChild(n._to_dom_worker(dom, document, serializer))

        for (k,v) in serializer.convert(self.iterattributes()):
            element.setAttribute(k,v)

    def _to_dom_worker(self, dom, document, serializer):
        element = document.createElement(self.__tag)
        self._append_to_dom_element(element, dom, document, serializer)
        return element

    def to_string(self, serializer=Serializer()):
        return self.to_dom(serializer).toxml("utf-8")

    def __repr__(self):
        args = [repr(self.__tag)]
        if len(self.__attributes) > 0:
            args.append(repr(self.__attributes))

        children = list(self.iternodes())
        if len(children) > 0:
            args.append(repr(children))

        return self.__class__.__name__ + "(" + ", ".join(args) + ")"

    def __str__(self):
        return self.to_string()

    @classmethod
    def _from_dom(cls, dom):
        return XElement(dom.tagName,
                        X._convert_named_node_map(dom.attributes),
                        X._convert_node_list(dom.childNodes))
    

class XProcessingInstruction(XNode):
    def __init__(self, target, text=u""):
        XNode.__init__(self)
        self.__target = unicode(target)
        self.__text = unicode(text)

    def target(self):
        return self.__target
    
    def text(self):
        return self.__text
    
    def _clone(self):
        return XProcessingInstruction(self.__target, self.__text)

    def __repr__(self):
        return (self.__class__.__name__ + "(" +
                ", ".join((repr(self.__target), repr(self.__text))) + ")")

    def _to_dom_worker(self, dom, document, serializer):
        return document.createProcessingInstruction(self.__target, self.__text)
    
    @classmethod
    def _from_dom(cls, dom):
        return XProcessingInstruction(dom.target, dom.data)


class XText(XNode):
    def __init__(self, text):
        XNode.__init__(self);
        self.__text = unicode(text)

    def text(self):
        return self.__text
    
    def _clone(self):
        return XText(self.__text)

    def __repr__(self):
        return self.__class__.__name__ + "(" + repr(self.__text) + ")"

    def _to_dom_worker(self, dom, document, serializer):
        return document.createTextNode(self.__text)
    
    @classmethod
    def _from_dom(cls, dom):
        return XText(dom.data)