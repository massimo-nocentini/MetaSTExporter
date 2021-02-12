
Introduction
============

In Smalltalk, a computation happens through sending messages. Period.  Messages
are so important to deserve half of browsers’ windows room for reading and
editing them; therefore, our effort to document a system concentrates on them.

A message couples a selector with a definition to have many implementations in
different classes. That allows triggering different computations when the same
selector is received and understood by objects that are instances of diverse
classes.

So our task is to describe a system and solve it by enumerating selectors
having messages we want to talk about. Occasionally we also want to reference
the classes that host them, and in general, to have pointers over them to
quickly jump back and forth.

A Smalltalk image is a safe sandbox for objects closed to other contexts. We
stick to Sphinx in favor of plain TeX to write our thoughts. So the two worlds
have to talk in some way using a serialization-agnostic representation, a JSON
ultimately.

On the one hand, a ``MetaSTExporter`` fulfills this task. We don't have a
schema for such an artifact, but we use a structure that had emerged naturally
to be easy to manipulate.

On the other hand, a new Sphinx domain consumes that output with two directives
to import both messages and classes code blocks within vanilla reStructuredText
source files. Additionally, two roles are also provided to support references.

We proceed backward, 

- the next section will show how to mix Smalltalk staff in Sphinx documentation,
- the next but one will show what's required from the Smalltalk side and, finally,
- the last one will show how ``MetaSTExporter`` objects export their implementation 
  to describe here themselves, recursively.
