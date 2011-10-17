Expectations
------------

Expectations is a small Dart library that gives you a more BDD-style way 
to write your `Expect` assertions.

**Built-in:** `Expect.equals("Rover", dog.name)`

**Using Expectations:** `expect(dog.name).toEqual("Rover")`

Although this is purely a syntactical feature, many find this syntax to 
be much easier to read.

Another benefit that this provides is the ability to seamlessly add your 
own functions that will be callable as `expect("foo").toBeMyCustomExpectation()`

As Dart doesn't provide any sort of mixins, you cannot add your own static 
functions to the `Expect` class, so you cannot have `Expect.myCustomExpectation("foo")`. 

Installing
----------

    wget https://raw.github.com/remi/expectations.dart/master/src/expectations.dart

Usage
-----

```actionscript
#include("expectations.dart");

testFoo() }
  var foo = new Foo(name: "Foo");
  expect(foo.name).toEqual("Foo");
}

main() {
  testFoo();
}
```

You can view [expectations.dart][] or look at the [test suite][] to see more ways 
to use Expectations and to see all of the expectation functions we provide, out of the box.

### Supported Expectation Functions

At the moment, we support every function that `Expect` provides (but we haven't 
added any new, useful expectation functions).

Here's a list of all of Expectations functions and the Expect functions that they call:

    toEqual(value, [String reason = null])
    Expect.equals(value, target, reason: reason)

    toEqualString(String value, [String reason = null])
    Expect.stringEquals(value, target, reason: reason)

    toEqualList(List value, [String reason = null])
    Expect.listEquals(value, target, reason: reason)

    toEqualSet(Set value, [String reason = null])
    Expect.setEquals(value, target, reason: reason)

    toNotEqual(value, [String reason = null])
    Expect.notEquals(value, target, reason: reason)

    toApproxEqual(num value, [num tolerance = null, String reason = null])
    Expect.approxEquals(value, target, tolerance: tolerance, reason: reason)

    toBeIdenticalTo(value, [String reason = null])
    Expect.identical(value, target, reason: reason)

    toBeTrue([String reason = null])
    Expect.isTrue(target, reason: reason)

    toBeFalse([String reason = null])
    Expect.isFalse(target, reason: reason)

    toBeNull([String reason = null])
    Expect.isNull(target, reason: reason)

    toNotBeNull([String reason = null])
    Expect.isNotNull(target, reason: reason)

    toThrow([check = null, String reason = null])
    Expect.throws(target, check: check, reason: reason)

Adding Custom Expectations
--------------------------

Okay, so let's say that your application has a custom Dog class.

You would like to write some custom expectations so that, in your 
specs, you can write something like:

```actionscript
testDogCreation() {
  var dog = new Dog.withBreed("Golden Retriever");
  expect(dog).toBeBreed("GoldenRetriever");
}
```

To make that work, the call to `expect(dog)` will need to 
return an object that has a `toBeBreed` function.

Expectations provides a hook that we call whenever `expect()` 
is called.  We pass the argument that was given to expect, 
eg. `"foo"` in `expect("foo")`, to the hook the the hook function 
can either return:

 * an object that has the expectation functions that you want, eg. `toBeBreed`
 * null, letting us know that your hook won't return an object, so we'll call the next hook

Here's what it would look like:

```actionscript
class DogExpectations {
  var dog;
  DogExpectations(this.dog);

  toBeBreed(breedName) {
    expect(dog.breed).toNotBeNull(reason: "Breed was null when checking for breed: $breedName");
    expect(dog.breed.name).toEqualString(breedName, reason: "Expected dog breed <$breedName> but was <${dog.breed.name}>");
  }
}

main() {
  Expectations.onExpect((target) =>
    return (target is Dog) ? new DogExpectations(target) : null);

  // ...
}
```

The call to `Expectations.onExpect()` lets you register a hook that 
we call with the target object.  You can check to see if the 
`target is Dog` and, if it is, return your custom object with 
custom expectations for Dog objects, eg. `toBeBreed`.

### Adding Custom Expectations to core classes

Okay, so the above example works great if you want to add custom expectations 
to a custom class of yours, eg. `Dog`.

But what if you want to add custom expectations to core Dart classes like String?

If you try to use the above implementation and return your custom object 
`if (target is String)`, that's problematic because you'll try to call something 
like `expect("foo").toEqual("bar")` and that'll throw a NoSuchMethodException 
because your custom object was returned (because the target is a String) and 
your custom object doesn't implement the `toEqual` expectation.

To get around this, all of expectations that are built into Expectations are defined 
in the `Expectations` class, making it easy for you to subclass it, giving 
you all of our built-in expectations.

```actionscript
class MyAwesomeSetofStringExpectations extends Expectations {
  MyAwesomeSetofStringExpectations(target){ this.target = target; }

  toBeAwesomeExpectation() {
    // I've added a new custom expectation here.
    // Because I've extended Expectations, I also have all 
    // of the built-in expectations like toEqual, toBeNull, etc.
  }

  // I can also override the build-in expectation functions!
  toEqualString(String otherString, [String reason = null]) {
    // my awesome, much better toEqualString implementation
  }
}

main() {
  Expectations.onExpect((target) =>
    return (target is String) ? new MyAwesomeSetofStringExpectations(target) : null);

  // ...
}
```

I realize that this isn't ideal ... but it works.

My favorite part of this implementation is that it gives you full control over what 
object you want to return from `expect()`.  You can just provide us with a function 
via `Expectations.onExpect` that figures out an object to return based on the target 
object provided ... you can write that logic however makes sense for you.

A Word about Implementation
---------------------------

The current implementation of expectations is kinda crap, in my opinion.

So how would you normally implement something like this?

Remember, here's the DSL we want: `expect(Dynamic object).toSomeCustomMethod()`

### Method Missing

Here's how we might implement this in Ruby:

```ruby
def expect(target)
  ExpectProxy.new(target)
end

class ExpectProxy
  attr_accessor :target

  def initialize(target)
    self.target = target
  end

  def method_missing(method_name, *method_arguments)
    # In here, we can look at the method_name and 
    # dynamically determine what we want to do
    "You called #{method_name} on #{target}"
  end
end

>> expect("Foo").to_be_awesome
=> "You called to_be_awesome on Foo"
```

PHP and other languages also provide `method_missing` like langauge features.

If your language has `method_missing` *and* mixins/open classes, then you don't 
need the `expect(target).toFoo` DSL because you can provide: `target.shouldBeFoo` 
by implementing your own `method_missing` for the target class, eg. `Object` or `String`

### Mixins and Open Classes

If your language gives you the ability to dynamically add methods to 
existing classes, eg. via including a module or some other mechanism, 
you could always implement expectations by adding the methods directly 
onto the objects that you want, eg.

```ruby
class AllExpectations
  # def to_equal
  # def whatever_else
end

def expect(target)
  AllExpectations.new(target)
end

module MyExpectations
  def to_be_awesome
    "You called to_be_awesome on #{target}"
  end
end

# Extend AllExpectations so it also includes the 
# methods defined in our MyExpectations module.

AllExpectations.send :include, MyExpectations

>> expect("Foo").to_be_awesome
=> "You called to_be_awesome on Foo"
```

As with `method_missing`, ofcourse, you wouldn't actually neat the `expect(target).toFoo` 
DSL if your language has mixins/open classes, because you can extend your target's 
class to include the methods you want, eg. extending `Object` to have a `shouldEqual` function.

### Extension Methods

C# has a unique compiler feature which could help you implement the `expect(target).toFoo` DSL 
but can also provide you with the ability to essentially "add new methods" to exising classes, 
like you get with mixins/open classes.

```c#
public static class MyExpectations {
  public static void shouldBeAwesome(this Object target) {
    Console.WriteLine("You called toBeAwesome with {0}", target);
  }
}

public class Program {
  public static void main(string[] args) {
    "foo".shouldBeAwesome();
  }
}
```

### Our Dart Implementation

Here's a general overview of our current implementation:

```actionscript
expect(var target) => Expectations.expect(target);

class Expectations {
  static expect(target) {
    // We have access to the target object here, eg. "Foo" if we called `expect("Foo").toBeAwesome()`
    //
    // Unfortunately, we can't see what function is being called ... so we have to guess what object 
    // to return (which will hopefully have a toBeAwesome() function) based purely on the target object.
    // 
    // Without any reflection, we can't even get the type of the object passed, although we can 
    // check it against types we already know about, eg. if (target is String)
    // 
    // So ... how do we determine what to return?
    //
    // We have a list of functions that, given a target, return either null or an instance of 
    // a class that expect() should return ... hopefully one which has a toBeAwesome() function!
    for (var fn in functionsThatTakeTarget) {
      var objectToReturn = fn(target);
      if (objectToReturn != null)
        return objectToReturn;
    }
    throw new CustomException("None of the functions that we passed this target to returned an object");
  }

  static List get functionsThatTakeTarget() {
    // this defaults to just 1 function that always returns an instance 
    // of Expectations, where all of our build-in expectations are defined
  }
}

class ChecksIfStringsAreAwesome {
  var target;
  ChecksIfStringsAreAwesome(this.target);
  toBeAwesome() {
    print("you called toBeAwesome for $target");
  }
}

main() {
  // Register our own function that returns our custom 
  // class which checks strings for awesomeness.
  Expectations.onExpect((target) {
    if (target is String)
      return new ChecksIfStringsAreAwesome(target);
    else
      return null;
  });

  expect("Foo").toBeAwesome();
}
```

So that's how we do it!

**NOTE:** a major problem with the above example is that it naively returns a 
ChecksIfStringsAreAwesome for *all* strings so `expect("Foo").toEqual("Bar") 
won't work because the ChecksIfStringsAreAwesome class has no toEqual function.

To help deal with this, all of the built-in expectations in Expectations are 
defined on the `Expectations` class so, if you subclass it, you'll get all of 
our default expecations which you can override or you can add your own.

### Future Dart Implementation

Gilad Bracha has been quoted saying *"[Dart] will eventually have mirror-based reflection"* [1][]

Once we se what Dart's future features are, we'll be able to (eventually) take advantage 
of them to provide DSLs like the one for Expectations.

Possible Future Features
------------------------

 * Extract out a general proxy pattern helper? 
 * Do people like the name of `expect()` and the expectations, eg. `toEqual` - if not, should we rename?

License
-------

expectations is released under the MIT license.

[1]:                 http://www.dartforce.com/doc/index.html
[expectations.dart]: https://github.com/remi/expectations.dart/blob/master/src/expectations.dart
[test suite]:        https://github.com/remi/expectations.dart/tree/master/spec
