# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'MetaSTExporter'
copyright = '2021, Massimo Nocentini and Richard Uttner'
author = 'Massimo Nocentini'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
        'sphinx.ext.mathjax',
        'sphinx.ext.githubpages',
        'sphinxcontrib.pharodomain',
        'sphinxcontrib.bibtex',
]

# For the bibliography.
bibtex_bibfiles = []

# The following configuation values concerns the Pharo domain.
pharo_json_export_filenames = [
        'source/core-messages.json',
        'source/example-messages.json',
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_theme_options = {
    "globaltoc_collapse": False,
    'github_user': 'massimo-nocentini',
    'github_repo': 'MetaSTExporter',
    'code_font_family': 'Monaco, Consolas',
    'code_font_size': '0.8em',
    'show_relbars': True,
    'fixed_sidebar':True,
    'page_width':'85%',
    'sidebarwidth':'30%',
    'pre_bg':'white',
    'note_bg':'white',
    'show_powered_by':False,
    'description': 'A lightweight tool for exporting Smalltalk stuff in a structured JSON.'
}

