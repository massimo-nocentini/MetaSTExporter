
Pharo's side
============

The examples we have seen in the previous section have been exported by the message

.. pharo:autocompiledmethod:: BaselineOfMetaSTExporter>>#scriptExportExampleMessagesForDoc

and that is all required to produce the JSON file. Of course

In order to produce my own documentation, the message 

.. pharo:autocompiledmethod:: BaselineOfMetaSTExporter>>#scriptExportCoreMessagesForDoc
   
has been defined, where

.. pharo:autocompiledmethod:: MetaSTExporter>>#selectors:

and
 
.. pharo:autocompiledmethod:: MetaSTExporter>>#exportWithRepositoryPath:ofPackage: 
.. pharo:autocompiledmethod:: MetaSTExporter>>#exportInFileReference:
.. pharo:autocompiledmethod:: MetaSTExporter>>#valueUsingDictionary:
