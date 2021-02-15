
Sphinx side
===========

Importing a ``CompiledMethod`` 
------------------------------

Let's start with importing the message 

.. pharo:autocompiledmethod:: Continuation_class>>#currentDo:

that captures a continuation. In the above code block we see, in order of appearance:

- the class that hosts the behaviour, the class-side of ``Continuation``,
- the protocol that the bahaviour belongs to, ``instance creation``,
- the selector interleaved with argument names, ``currentDo: aBlock``,
- the body that express the computation, ``^ aBlock value: (self fromContext: thisContext sender)``.

Such code block has been inserted with the Sphinx directive

.. rst:directive:: .. pharo:autocompiledmethod::  Continuation_class>>#currentDo:

that also adds an entry to each of the following index labels,

- ``#currentDo:`` is understood by,
- a Continuation class understands,
- Protocol instance creation.

Importing a ``Class``
---------------------

We can also import the previously seen ``Continuation`` class-side

.. pharo:autoclass:: Continuation_class
  :include-comment: yes

including the class comment; in parallel, the corresponding Sphinx code looks like this

.. rst:directive:: .. pharo:autoclass:: Continuation_class

  .. rst:directive:option:: include-comment: yes
  
.. note::

  The newly directives are inspired by Python's `.. automethod::
  <https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#directive-automethod>`_
  and `.. autoclass::
  <https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html#directive-autoclass>`_
  respectively.

In order to explain the body of ``#currentDo:`` we might also need

.. pharo:autocompiledmethod:: BlockClosure>>#value:

hosted in 

.. pharo:autoclass:: BlockClosure
  :include-comment: yes

both included in this documentation with

.. rst:directive:: .. pharo:autocompiledmethod:: BlockClosure>>#value:

and

.. rst:directive:: .. pharo:autoclass:: BlockClosure

  .. rst:directive:option:: include-comment: yes

respectively. Observe that it is straightforward to report another message for
the selector ``#value:``, 

.. pharo:autocompiledmethod:: Association>>#value:

for instance, hosted in

.. pharo:autoclass:: Association

quickly.

Referencing
-----------

We also can reference both a class that appears in the documentation, as for :pharo:cref:`BlockClosure` with the role

.. rst:role:: pharo:cref

  Accepts the name of the class we want to reference, between ````` symbols.

and a compiled method, as for :pharo:mref:`BlockClosure>>#value:` with the role

.. rst:role:: pharo:mref

  Accepts the signature ``α >> #β``, where ``α`` is a class name and ``β`` is a
  valid selector, we want to reference, between ````` symbols.
