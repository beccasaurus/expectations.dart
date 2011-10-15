#library("expectations");

// Given any type of object, this returns a proxy 
// object that ...
Expectable expect(var target) => Expectations.expect(target);

interface Expectable {}

class Expectations implements Expectable {

  var target;

  Expectations(this.target);

  static Expectable expect(var target) {
    // TODO have this ask abunchof functions for instances to use ... return the first?
    //      this will be useful when you want to make expectations for your own Types ...
    //
    // expect(new Dog()).toBeValid();
    // expect(new Cat()).toBeValid();
    return new Expectations(target);
  }

  void toEqual(var value) {
    Expect.equals(value, target); // Message support?
  }

  void toNotEqual(var value) {
    Expect.notEquals(value, target); // Message support?
  }
}
