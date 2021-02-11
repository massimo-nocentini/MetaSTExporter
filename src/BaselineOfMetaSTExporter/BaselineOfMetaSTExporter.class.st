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
		  selectors: #( selectors: #exportWithRepositoryPath:ofPackage: );
		  exportWithRepositoryPath: [ :aPath | 
			  aPath / 'booklet' / 'source' / 'core-messages.json' ]
		  ofPackage: self class package
]
