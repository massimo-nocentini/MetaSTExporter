
Installation
============

To start go to a safe sandbox in your filesystem. 

First, create a Python virtual env,

.. code-block:: bash

  $ python3 -m venv venv
  $ source venv/bin/activate
  $ pip install sphinx
   
Second, install the Sphinx extensions ``sphinxcontrib.pharodomain``,

.. code-block:: bash

  (venv) $ git clone git@github.com:massimo-nocentini/pharodomain.git
  (venv) $ pip install pharodomain

Third, load ``MetaSTExporter`` in an image that suites you,

.. code-block:: smalltalk

  Metacello new
    baseline: 'MetaSTExporter';
    repository: 'github://massimo-nocentini/MetaSTExporter/src';
    load.

Fourth, change directory to the Iceberg repo folder of the project you want to document
and create a new booklet there, for instance by

.. code-block:: bash

  (venv) $ sphinx-quickstart

and update the ``conf.py`` with

.. code-block:: python

  extensions = [
        ...,
        'sphinxcontrib.pharodomain',
        ...,
  ]

  pharo_json_export_filenames = [
        ...,
        '<filename1-of-export-output.json>',
        '<filename2-of-export-output.json>',
        ...,
  ]

then enjoy your doc.
