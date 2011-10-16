Expectations
------------

**NOT YET RELEASED - CHECK BACK SOON**

Installing
----------

Usage
-----

A Word about Implementation
---------------------------

The current implementation of expectations is crap.

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

PHP and other languages also provide `method\_missing` like langauge features.

If your language has `method\_missing` *and* mixins/open classes, then you don't 
need the `expect(target).toFoo` DSL because you can provide: `target.shouldBeFoo` 
by implementing your own `method\_missing` for the target class, eg. `Object` or `String`

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

As with `method\_missing`, ofcourse, you wouldn't actually neat the `expect(target).toFoo` 
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
    // So ... how do we determins what to return?
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

License
-------

expectations is released under the MIT license.

[1]: http://www.dartforce.com/doc/index.html
