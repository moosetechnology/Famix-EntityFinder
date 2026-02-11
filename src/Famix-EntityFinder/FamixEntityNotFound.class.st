Class {
	#name : 'FamixEntityNotFound',
	#superclass : 'NotFound',
	#category : 'Famix-EntityFinder',
	#package : 'Famix-EntityFinder'
}

{ #category : 'private' }
FamixEntityNotFound >> standardMessageText [

	^ String streamContents: [ :stream |
		  stream << self object << ' not found in '
		  << self collection mooseName ]
]
