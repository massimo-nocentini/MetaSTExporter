Class {
	#name : #BaselineOfMetaSTExporter,
	#superclass : #BaselineOf,
	#category : #BaselineOfMetaSTExporter
}

{ #category : #baselines }
BaselineOfMetaSTExporter >> baseline: spec [

	<baseline>
	spec for: #common do: [ spec package: 'MetaSTExporter' ]
]

{ #category : #export }
BaselineOfMetaSTExporter >> scriptExportCoreMessagesForDoc [

	<script:
	'BaselineOfMetaSTExporter new scriptExportCoreMessagesForDoc'>
	^ MetaSTExporter new
		  selectors: #( selectors: #exportWithRepositoryPath:ofPackage:
			     scriptExportCoreMessagesForDoc exportInFileReference:
			     valueUsingDictionary: currentDo: value: );
		  exportWithRepositoryPath: [ :aPath | 
			  aPath / 'booklet' / 'source' / 'core-messages.json' ]
		  ofPackage: self class package
]

{ #category : #export }
BaselineOfMetaSTExporter >> scriptExportExampleMessagesForDoc [

	<script:
	'BaselineOfMetaSTExporter new scriptExportExampleMessagesForDoc'>
	^ MetaSTExporter new
		  selectors: #( currentDo: value: );
		  exportWithRepositoryPath: [ :aPath | 
			  aPath / 'booklet' / 'source' / 'example-messages.json' ]
		  ofPackage: self class package
]
