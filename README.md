# Famix-EntityFinder

Helper to find entities in Famix models.

See methods available on the `FamixEntityFinder` class.  
See also `FamixJavaEntityFinder` to handle Java intricacies, for example to find methods with signatures that use [field descriptors](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.3.2).

## Installation

```st
Metacello new
  githubUser: 'moosetechnology' project: 'Famix-EntityFinder' commitish: 'main' path: 'src';
  baseline: 'FamixEntityFinder';
  load
```

As a dependency:
```st
spec
  baseline: 'FamixEntityFinder'
  with: [ spec repository: 'github://moosetechnology/Famix-EntityFinder:main/src' ]
```

## Usage

Initialize a finder by giving it a Famix model to search:
```st
finder := FamixJavaEntityFinder new model: myModel.
"Or more briefly"
finder := FamixJavaEntityFinder on: myModel.
```

Then run queries using the available API.
Some examples are given below.

Find a type using a name, qualified or not, with support for arrays:
```st
finder findTypeNamed: 'Object'.
finder findTypeNamed: 'java.lang.Object'.
finder findTypeNamed: 'Object[]'. "FamixValueJavaArray wrapper around Famix entity"
```

Find a method using a signature:
```st
arrays := finder findTypeNamed: 'java.util.Arrays'.
finder findMethodWithSignature: 'copyOf([B,int)' in: arrays. "copyOf(byte[] original, int newLength)"
finder findMethodWithSignature: 'equals([Ljava.lang.Object;,[Ljava.lang.Object;)' in: arrays. "equals(Object[] a, Object[] a2)"
```
