
Pharo side
==========

The messages ``#currentDo:`` and ``#value:`` with the companion classes we have
seen in the previous section have been exported by the message

.. pharo:autocompiledmethod:: BaselineOfMetaSTExporter>>#scriptExportExampleMessagesForDoc

and that is all required to produce the JSON file. Take a deeper look at
messages exchanged there, first a simple accessor

.. pharo:autocompiledmethod:: MetaSTExporter>>#selectors:

second, an utility
 
.. pharo:autocompiledmethod:: MetaSTExporter>>#exportWithRepositoryPath:ofPackage: 

that eventually forwards to

.. pharo:autocompiledmethod:: MetaSTExporter>>#exportInFileReference:

leaving, in turn, the duty to

.. pharo:autocompiledmethod:: MetaSTExporter>>#valueUsingDictionary:

Of course, since ``MetaSTExporter`` objects are Smalltalk material, they can be used 
to export their own messages by the following

.. pharo:autocompiledmethod:: BaselineOfMetaSTExporter>>#scriptExportCoreMessagesForDoc

so that previously we was able to document their messages.
