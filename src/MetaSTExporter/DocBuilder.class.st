"
I am a prototype of a documentation exporter (or builder) that generate a structured representation of the concepts catched and written for classes and messages.

## Example

After a discussion with Richard Uttner, we agreed to investigate the following approach:

Directory Realog documentation:
	- Realog.json 'this file contains a kind of `db` for all the collected topics.'
	- Realog_state.markup 'this file will contain the class comment.'
	- Realog_State_walk.markup 'this file is generated because the pragma `<doc: 'Realog' topic: #(State walk) > has been encontered.'
	- Realog_State_walk_inDictionary.markup 'this file is generated because the pragma `<doc: 'Realog' topic: #(State walk inDictionary) > has been encontered.'

In each markup file the corresponding chunk of code will be added to the bottom, both 
at the first creation and after each change to the source code in the Smalltalk image. 
For instance:

[[[ 
walk: anObj
...
]]]

"
Class {
	#name : #DocBuilder,
	#superclass : #Object,
	#instVars : [
		'selectors'
	],
	#category : #MetaSTExporter
}

{ #category : #evaluating }
DocBuilder >> encodeClass: aClass [

	| aDictionary |
	aDictionary := Dictionary new.

	^ aDictionary
		  at: #definition put: aClass definition;
		  at: #comment put: aClass comment lines;
		  at: #category put: aClass category;
		  at: #hash put: aClass hash;
		  yourself
]

{ #category : #'as yet unclassified' }
DocBuilder >> encodeCompiledMethod: each ofSelector: aSelector [

	^ Dictionary new
		  at: #argumentNames put: each argumentNames;
		  at: #comment put: (each comment ifNil: [ '' ]) lines;
		  at: #category put: each category;
		  at: #body put: each sourceNode body formattedCode lines;
		  at: #sourceCode put: each sourceNode formattedCode lines;
		  at: #hash put: each hash;
		  "codeForNoSource"yourself
]

{ #category : #evaluating }
DocBuilder >> encodeSelector: aSelector [

	| aDictionary |
	aDictionary := Dictionary new.

	^ aDictionary
		  at: #implementors
		  put: (aSelector implementors collect: [ :each | 
					   each methodClass
					   -> (self encodeCompiledMethod: each ofSelector: aSelector) ])
				  asDictionary;
		  at: #senders
		  put: (aSelector senders collect: [ :each | each name ] as: Array);
		  yourself
]

{ #category : #evaluating }
DocBuilder >> encodeSelector: aSelector inDictionary: aDictionary [

	| compiledMethods newDict |
	compiledMethods := aSelector implementors
		                   ifEmpty: [ 
		                   Error signal: aSelector , ' has no implementors.' ]
		                   ifNotEmpty: [ :implementors | 
			                   implementors select: [ :each | 
				                   (aDictionary at: #messages)
					                   at: aSelector
					                   ifPresent: [ :selectorDict | 
						                   (selectorDict at: #implementors)
							                   at: each methodClass name
							                   ifPresent: [ :messageDict | 
							                   (messageDict at: #hash) ~= each hash ]
							                   ifAbsent: [ true ] ]
					                   ifAbsent: [ true ] ] ].
	newDict := (compiledMethods collect: [ :each | 
		            each methodClass
		            ->
		            (self encodeCompiledMethod: each ofSelector: aSelector) ])
		           asDictionary.
	newDict keysAndValuesDo: [ :k :v | 
		| dict |
		dict := (aDictionary at: #messages) at: aSelector ifAbsentPut: [ 
			        Dictionary new
				        at: #implementors put: Dictionary new;
				        yourself ].
		(dict at: #implementors) at: k put: v ].
	^ ((aDictionary at: #messages) at: aSelector)
		  at: #senders
		  put: (aSelector senders collect: [ :each | each name ] as: Array);
		  yourself
]

{ #category : #evaluating }
DocBuilder >> exportInFileReference: aFileReference [

	| json |
	json := aFileReference exists
		        ifTrue: [ 
			        aFileReference readStreamDo: [ :readStream | 
				        STONJSON fromStream: readStream ] ]
		        ifFalse: [ 
			        Dictionary new
				        at: #classes put: Dictionary new;
				        at: #messages put: Dictionary new;
				        yourself ].
	(json at: #messages) valuesDo: [ :aDict | 
		(aDict at: #implementors) in: [ :childDict | 
			childDict associations do: [ :anAssoc | 
				| className |
				className := (anAssoc key endsWith: ' class')
					             ifTrue: [ (anAssoc key splitOn: ' class') first ]
					             ifFalse: [ anAssoc key ].
				childDict
					at: (Smalltalk at: className asSymbol)
					put: anAssoc value.
				childDict removeKey: anAssoc key ] ] ].
	json := self valueUsingDictionary: json.
	aFileReference writeStreamDo: [ :writeStream | 
		STONJSON put: json onStreamPretty: writeStream ].
	^ json
]

{ #category : #evaluating }
DocBuilder >> exportWithRepositoryPath: aBlock ofPackage: aPackage [

	| aPath |
	aPath := aBlock value:
		         (IceRepository registeredRepositoryIncludingPackage:
			          aPackage) repositoryDirectory asPath.
	^ self exportInFileReference: aPath asFileReference
]

{ #category : #accessing }
DocBuilder >> selectors: anObject [

	selectors := anObject
]

{ #category : #evaluating }
DocBuilder >> value [

	| aDictionary messages classes |
	aDictionary := Dictionary new.
	messages := (selectors collect: [ :eachSelector | 
		             eachSelector -> (self encodeSelector: eachSelector) ])
		            asDictionary.


	classes := (messages values collect: [ :each | 
		            each at: #implementors ]) flatCollect: #keys as: Set.
	aDictionary
		at: #classes
		put:
			(classes collect: [ :each | each name -> (self encodeClass: each) ])
				asDictionary.

	messages valuesDo: [ :each | 
		each at: #implementors ifPresent: [ :aDict | 
			each
				at: #implementors
				put: (aDict associations collect: [ :anAssoc | 
						 anAssoc key name -> anAssoc value ]) asDictionary ] ].
	aDictionary at: #messages put: messages.

	^ aDictionary
]

{ #category : #evaluating }
DocBuilder >> valueUsingDictionary: aDictionary [

	| messages classes |
	messages := (selectors collect: [ :eachSelector | 
		             eachSelector
		             ->
		             (self
			              encodeSelector: eachSelector
			              inDictionary: aDictionary) ]) asDictionary.


	classes := (messages values collect: [ :each | 
		            each at: #implementors ]) flatCollect: #keys as: Set.
	aDictionary
		at: #classes
		put:
			(classes collect: [ :each | each name -> (self encodeClass: each) ])
				asDictionary.

	messages valuesDo: [ :each | 
		each at: #implementors ifPresent: [ :aDict | 
			each
				at: #implementors
				put: (aDict associations collect: [ :anAssoc | 
						 anAssoc key name -> anAssoc value ]) asDictionary ] ].
	aDictionary at: #messages put: messages.

	^ aDictionary
]
