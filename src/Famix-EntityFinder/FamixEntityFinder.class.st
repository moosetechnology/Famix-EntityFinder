"
An importer helper to find types in a Famix model, based on the usage of the `FamixTType` trait.
"
Class {
	#name : 'FamixEntityFinder',
	#superclass : 'Object',
	#instVars : [
		'model',
		'cache',
		'replacements',
		'createNotFound',
		'expectedType'
	],
	#category : 'Famix-EntityFinder',
	#package : 'Famix-EntityFinder'
}

{ #category : 'instance creation' }
FamixEntityFinder class >> on: aModel [

	^ self new model: aModel
]

{ #category : 'accessing' }
FamixEntityFinder >> cache [

	^ cache ifNil: [ cache := Dictionary new ]
]

{ #category : 'configuring' }
FamixEntityFinder >> clearCache [

	cache := Dictionary new
]

{ #category : 'configuring' }
FamixEntityFinder >> clearFromCache: cacheKey [

	cache removeAt: cacheKey
]

{ #category : 'accessing' }
FamixEntityFinder >> createNotFound [

	^ createNotFound
]

{ #category : 'accessing' }
FamixEntityFinder >> createNotFound: aBoolean [

	createNotFound := aBoolean
]

{ #category : 'configuring' }
FamixEntityFinder >> createWhenNotFound [
	"When there is no search result, create the entity in the model."

	self createNotFound: true
]

{ #category : 'enumerating' }
FamixEntityFinder >> detectType: predicate [

	^ (expectedType
		   ifNotNil: [
			   expectedType isTrait
				   ifTrue: [ self model allUsing: expectedType ]
				   ifFalse: [ self model allWithType: expectedType ] ]
		   ifNil: [ self model allTypes ]) detect: predicate ifNone: [  ]
]

{ #category : 'configuring' }
FamixEntityFinder >> errorWhenNotFound [
	"When there is no search result, signal a FamixEntityNotFound error."

	self createNotFound: false
]

{ #category : 'accessing' }
FamixEntityFinder >> expectedType [

	^ expectedType
]

{ #category : 'accessing' }
FamixEntityFinder >> expectedType: aFamixEntityClassOrTrait [

	expectedType := aFamixEntityClassOrTrait
]

{ #category : 'configuring' }
FamixEntityFinder >> expecting: aFamixEntityClassOrTrait do: aBlock [
	"Set the expected entity class or trait found during searches in the block.
	Useful to optimize searches by scanning only the relevant entities,
	and for typing entities correctly when used with `createWhenNotFound`.
	E.g., finder expecting: FamixJavaInterface do: [ finder findTypeNamed: 'Map' ]"

	| expectedAround result |
	expectedAround := expectedType.
	expectedType := aFamixEntityClassOrTrait.
	result := aBlock value.
	expectedType := expectedAround.
	^ result
]

{ #category : 'enumerating' }
FamixEntityFinder >> findMethodWithSignature: signature in: class [

	| candidates |
	class methods
		detect: [ :method | method signature = signature ]
		ifFound: [ :method | ^ method ].

	"Signature might not exactly match due to representation format"
	candidates := self
		              findMethodsWithName:
		              (self methodNameFromSignature: signature)
		              in: class.
	candidates size = 1 ifTrue: [ ^ candidates anyOne ].

	"Method might be overloaded, find the one with matching signature"
	candidates := candidates select: [ :method |
		              self signatureOf: method matches: signature ].
	candidates size = 1 ifTrue: [ ^ candidates anyOne ].
	candidates ifEmpty: [ ^ self methodNotFound: signature in: class ].
	self error: 'Found multiple methods matching signature: ' , signature
]

{ #category : 'enumerating' }
FamixEntityFinder >> findMethodsWithName: name in: class [

	^ class methods select: [ :method | method name = name ]
]

{ #category : 'enumerating' }
FamixEntityFinder >> findTypeNamed: name [
	"Main API for finding a type, should not be overridden."

	| actualName |
	actualName := self replacements at: name ifAbsent: [ name ].
	^ self cache at: actualName ifAbsentPut: [
		  (self parseTypeName: actualName) ifNotNil: [ :type |
			  type isParametricEntity
				  ifTrue: [ type genericEntity ]
				  ifFalse: [ type ] ] ]
]

{ #category : 'enumerating' }
FamixEntityFinder >> findTypeWithMooseName: name [

	^ self detectType: [ :type | type mooseName = name ]
]

{ #category : 'enumerating' }
FamixEntityFinder >> findTypeWithName: name [

	^ self detectType: [ :type | type name = name ]
]

{ #category : 'initialization' }
FamixEntityFinder >> initialize [

	createNotFound := false
]

{ #category : 'enumerating' }
FamixEntityFinder >> methodNameFromSignature: signature [

	^ signature
]

{ #category : 'entity creation' }
FamixEntityFinder >> methodNotFound: signature in: class [

	createNotFound
		ifTrue: [
			^ (self model newMethodNamed:
					   (self methodNameFromSignature: signature))
				  signature: signature;
				  parentType: class;
				  yourself ]
		ifFalse: [ FamixEntityNotFound signalFor: signature in: class ]
]

{ #category : 'accessing' }
FamixEntityFinder >> model [

	^ model ifNil: [ model := FamixModel new ]
]

{ #category : 'accessing' }
FamixEntityFinder >> model: aFamixModel [

	model := aFamixModel
]

{ #category : 'enumerating' }
FamixEntityFinder >> parseTypeName: name [
	"This method can be overriden to modify how the search is executed."

	^ self findTypeWithName: name
]

{ #category : 'configuring' }
FamixEntityFinder >> replace: aTypeName with: anotherTypeName [

	self replacements at: aTypeName put: anotherTypeName
]

{ #category : 'accessing' }
FamixEntityFinder >> replacements [

	^ replacements ifNil: [ replacements := Dictionary new ]
]

{ #category : 'accessing' }
FamixEntityFinder >> replacements: aDictionary [
	"Map name strings to alternate names, applied before search in model."

	replacements := aDictionary
]

{ #category : 'matching' }
FamixEntityFinder >> signatureOf: method matches: signature [

	^ method signature = signature
]

{ #category : 'entity creation' }
FamixEntityFinder >> typeNotFound: typeName [

	createNotFound
		ifTrue: [ ^ self model newTypeNamed: typeName ]
		ifFalse: [ FamixEntityNotFound signalFor: typeName ]
]
