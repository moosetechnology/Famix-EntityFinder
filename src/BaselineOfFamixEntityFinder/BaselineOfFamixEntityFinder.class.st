Class {
	#name : 'BaselineOfFamixEntityFinder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFamixEntityFinder',
	#package : 'BaselineOfFamixEntityFinder'
}

{ #category : 'baselines' }
BaselineOfFamixEntityFinder >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec package: 'Famix-EntityFinder'.

		spec group: 'default' with: #( 'Famix-EntityFinder' ) ]
]
