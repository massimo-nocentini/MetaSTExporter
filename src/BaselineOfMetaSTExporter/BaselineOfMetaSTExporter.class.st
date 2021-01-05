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
