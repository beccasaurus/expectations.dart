# Expectations

**Website:** [http://remi.github.com/expectations.dart][web]

[Dart][] comes out of the box with a good set of expectations via [Expect][].

Unfortunately, there are some problems with Expect:

 1. There's no way to extend it to add additional expectations, so you would have to 
use Expect for some expectations and MyExpect for others.  Not ideal.
 2. Not everyone likes the `Expect.equals(A, B)` syntax.  I always forget, which 
argument is the actual and which one is the expected?  Ugh.

Enter `expectations.dart`!

## Get it!

Download [the latest version of **expectations.dart**][latest]

## Usage

```actionscript
#import("expectations.dart");

testWithoutExpectations() {
  Expect.equals("Rover", dog.name);
  Expect.notEquals("Spot", dog.name);
  Expect.stringEquals("Rover", dog.name);
  Expect.identical(expectedDog, dog);
}

testWithExpectations() {
  expect(dog.name) == "Rover";
  expect(dog.name).not == "Rover";
  expect(dog.name).equalsString("Rover"); // or toEqualString  [ToBeExpectations]
  expect(dog).identical(expectedDog);     // or toBe           [ToBeExpectations]
}
```

That's pretty much all there is to it!

### What methods can I call?

Expectations comes out of the box with support for every method that [Expect][] has:

 * `Expect.approxEquals` becomes `expect().approxEquals`
 * `Expect.equals` becomes `expect().equals`
 * `Expect.fail` becomes `expect().fail`
 * ... etc ...
 * See [CoreExpectations][] for API documentation for all methods

Our [CoreExpectations][] were designed to be as similar to [Expect][]'s methods as possible. 
We also based this on [another implementation][unittest_expect] of `expect()` that's used in the Dart [unittest][] 
test framework, trying to match their implementation as much as possible.

### ToBeExpectations

Out of the box, Expectations' methods look like: 

 * `expect().equals`
 * `expect().isNull`
 * `expect().identical`

While this is a perfectly acceptable API, another popular testing framework ([Jasmine][]) has a slightly 
different API:

 * `expect().toEqual`
 * `expect().toBeNull`
 * `expect().toBe`

In support of both common APIs, you can configure Expectations to use [ToBeExpectations][] instead of 
[CoreExpectations][].

### How do I create/register new expectation methods?

Let's say you want to implement `expect().toBeAwesome`.  First, you need to make a class with the `toBeAwesome` 
method on it.  The `expect()` method will return an instance of your class, so `toBeAwesome` can be called on it:

```actionscript
class AwesomeExpectations {
  var target;

  // When expect() is called with an object, eg. expect("foo"), 
  // we instantiate a new instance of the Expectation class, passing 
  // it the target object, eg. "foo" in the case of expect("foo")
  AwesomeExpectations(this.target);

  toBeAwesome() {
    Expect.isTrue(target.isAwesome);
  }
}
```

Now that you have your class, we need to tell Expectations to return a `new AwesomeExpectations(target)` whenever 
`expect()` is called, instead of returning the default ([CoreExpectations][]).

```actionscript
Expectations.onExpect((target) => new AwesomeExpectations(target));
```

That's it!  Now, whenever `expect()` is called, we will call the closure that you passed to onExpect, 
passing it the target object so you can instantiate a `new AwesomeExpectations(target)` and we'll return 
that from `expect()`.

Now you can call `expect("foo").toBeAwesome()`.

Okay, but now what happens when you try to call `expect("foo").equals("bar")`?

Your `AwesomeExpectations` class doesn't have an `equals` function, so it'll blow up with a `NoSuchMethodException`!

### Extending CoreExpectations

Let's say that you want to add a new `toBeAwesome` expectation method, but you still want to be able to use 
all of the default expectations, eg. `equals`, `isNull`, etc.

The easiest say to do this is to simply make your custom expectation class `extend CoreExpectations`, which 
is where all of our default expectations are defined.

```actionscript
// If your class extends CoreExpectations, you'll get all of our 
// default expectations.  Note: you can also extend ToBeExpectations.
class AwesomeExpectations extends CoreExpectations {

  // CoreExpectations already has a target field so you 
  // can simply call the parent constructor.
  AwesomeExpectations(var target) : super(target);

  // Add you own expectations
  toBeAwesome(){ Expect(target.isAwesome).isTrue }

  // Or even override the defaults!
  equals(value, [String reason = null]) {
    // my awesome implementation
  }
}
```

That's great, but let's say that we want to make a couple of different classes, each providing 
expectations for a specific class, eg. `DogExpectations` and `CatExpectations`, because the 
`Dog` and `Cat` classes are business objects that we work with a lot.

The closure that you pass to `Expectations.onExpect` can return null to "opt-out" of returning 
an instance of your Expectation class.

```actionscript
// Register our Expectation classes
Expectations.onExpect((target) => (target is Dog) ? DogExpectations : null);
Expectations.onExpect((target) => (target is Cat) ? CatExpectations : null);

// This works because "foo" isn't a Dog/Cat so we'll get CoreExpectations as usual
expect("foo").equals(5);

// This works because we're passing a Dog so we'll get a DogExpectations
// (assuming DogExpectations implements the 'isBreed' method)
expect(rover).isBreed("Golden Retriever");

// This will work *if* your DogExpectations class extends CoreExpectations 
// or if your DogExpectations has its own 'identical' method
expect(rover).identical(rex);
```

That's really all there is to it.

## License

Expectations is released under the [MIT license][mit].

[latest]:           https://raw.github.com/remi/expectations.dart/master/pkg/expectations.dart
[web]:              http://remi.github.com/expectations.dart
[Dart]:             http://www.dartlang.org/
[Expect]:           http://www.dartlang.org/docs/api/Expect.html#Expect::Expect
[unittest]:         http://code.google.com/p/dart/source/browse/trunk/dart/client/testing/unittest/unittest.dart
[unittest_expect]:  http://code.google.com/p/dart/source/browse/trunk/dart/client/testing/unittest/shared.dart?r=1334#41
[CoreExpectations]: http://remi.github.com/expectations.dart/CoreExpectations.html#CoreExpectations::CoreExpectations
[ToBeExpectations]: http://remi.github.com/expectations.dart/ToBeExpectations.html#ToBeExpectations::ToBeExpectations
[Jasmine]:          http://pivotal.github.com/jasmine/
[mit]:              http://www.opensource.org/licenses/mit-license.php
