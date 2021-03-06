Extension { #name : #BlockClosure }

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> arguments [
	^#()
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> asClosedBlock [
	^ PjClosedBlockClosure
		outerContext: self outerContext
		startpc: self startpc
		numArgs: self numArgs
		copiedValues: self copiedValuesForClosedBlock
		originalBlock: self
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> asValuedBlock [
	^PjValuedClosedBlockClosure newFrom: self
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> asValuedBlockWithArgs: args [
	^PjValuedClosedBlockClosure newFrom: self withArgs: args
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> convertToJavascriptAstUsing: aPjAstConverter [
	^ aPjAstConverter visit: self
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> convertToJsUsing: aPjTranspiler [ 
	aPjTranspiler convertBlock: self
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> copiedValues [
	^(1 to: self numCopiedValues) collect: [: index | 
		self copiedValueAt: index].
	
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> copiedValuesForClosedBlock [
	^self copiedValues collect: [ : each | each copy ]
	
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> externalVariable: name fromContext: context [
	^ PjJavascriptTranspilationError new messageText: 'free temp variable: ',name
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> externalVariable: name fromMethod: method [
	^ PjJavascriptTranspilationError new messageText: 'free instance variable: ',name
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> externalVariables [
	^ self externalVariablesOf: self
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> externalVariablesOf: aBlock [
	| context method variables |
	variables := Dictionary new.
	context := aBlock outerContext.
	[ context isNil ] whileFalse: [
		context tempNames do: [ : name |
			[
				variables at: name put: (self externalVariable: name fromContext: context)
			] on: Error do: [ nil ]
		].
		context := context outerContext
	].
	method := aBlock home receiver.
	method class allInstVarNames do: [ : name |
		variables at: name put: (self externalVariable: name fromMethod: method)
	].
	^ variables

]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> firstAstNode [
	^self sourceNode statements first
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> isClosed [
	^ false
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> isLiteralJavascriptValue [
	^ self isClosed
]

{ #category : #'*PharoJsTranspiler' }
BlockClosure >> originalBlock [
	^ self
]
