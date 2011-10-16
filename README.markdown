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

License
-------

expectations is released under the MIT license.
