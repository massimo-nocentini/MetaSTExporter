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

{ #category : #encoding }
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

{ #category : #encoding }
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

{ #category : #encoding }
DocBuilder >> encodeSelector: aSelector inDictionary: aDictionary [

	| compiledMethods selectorDict |
	selectorDict := (aDictionary at: #messages)
		                at: aSelector
		                ifAbsentPut: [ 
			                Dictionary new
				                at: #implementors put: Dictionary new;
				                yourself ].
	compiledMethods := aSelector implementors
		                   ifEmpty: [ 
		                   Error signal: aSelector , ' has no implementors.' ]
		                   ifNotEmpty: [ :implementors | 
			                   | implementorsDict |
			                   implementorsDict := selectorDict at:
				                                       #implementors.
			                   implementors select: [ :each | 
				                   implementorsDict
					                   at: each methodClass
					                   ifPresent: [ :messageDict | 
					                   (messageDict at: #hash) ~= each hash ]
					                   ifAbsent: [ true ] ] ].
	compiledMethods
		do: [ :each | 
			(selectorDict at: #implementors)
				at: each methodClass
				put: (self encodeCompiledMethod: each ofSelector: aSelector) ]
		displayingProgress: [ :each | each printString ].

	^ selectorDict
		  at: #senders
		  put: (aSelector senders collect: [ :each | each name ] as: Array);
		  yourself
]

{ #category : #export }
DocBuilder >> exportInFileReference: aFileReference [

	| json messages |
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
			childDict associations
				do: [ :anAssoc | 
					| class |
					class := (anAssoc key endsWith: ' class')
						         ifTrue: [ 
							         | className |
							         className := (anAssoc key splitOn: ' class') first.
							         (Smalltalk at: className asSymbol) class ]
						         ifFalse: [ Smalltalk at: anAssoc key asSymbol ].
					childDict at: class put: anAssoc value.
					childDict removeKey: anAssoc key ]
				displayingProgress: [ :each | 'Reified class ' , each key ] ] ].
	messages := self valueUsingDictionary: json.
	messages valuesDo: [ :each | 
		(each at: #implementors) in: [ :aDict | 
			each
				at: #implementors
				put: (aDict associations collect: [ :anAssoc | 
						 anAssoc key name -> anAssoc value ]) asDictionary ] ].
	json at: #messages put: messages.

	aFileReference writeStreamDo: [ :writeStream | 
		STONJSON put: json onStreamPretty: writeStream ].

	^ json
]

{ #category : #export }
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
DocBuilder >> valueUsingDictionary: aDictionary [

	| messages classes |
	
	messages := Dictionary new.
	selectors
		do: [ :eachSelector | 
			messages
				at: eachSelector
				put: (self encodeSelector: eachSelector inDictionary: aDictionary) ]
		displayingProgress: [ :each | 'Exporting selector: #' , each ].

	classes := (messages values collect: [ :each | 
		            each at: #implementors ]) flatCollect: #keys as: Set.
	classes
		do: [ :aClass | 
			(aDictionary at: #classes)
				at: aClass name
				put: (self encodeClass: aClass) ]
		displayingProgress: [ :aClass | 'Exporting class: ' , aClass name ].

	^ messages
]
