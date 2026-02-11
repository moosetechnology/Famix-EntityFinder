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
		spec
			baseline: 'FamixValue'
			with: [ "For Java arrays, though it might be good to decouple it in the future"
				spec
					repository: 'github://moosetechnology/Famix-Value:main/src';
					loads: 'types' ].

		spec package: 'Famix-EntityFinder'.

		spec group: 'default' with: #( 'Famix-EntityFinder'
		   'FamixValue' ) ]
]
