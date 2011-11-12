/**
 * [:expect():] returns an [Expectationable] object that has the functions 
 * you want to call on it, eg. isNull for expect(foo).isNull
 *
 * An [Expectationable] class has a constructor that takes any type 
 * of object and provides functions that make Expect assertions on 
 * that object, eg. [:new MyExpectationable("Foo").toEqual("Bar"):]
 *
 * An [Expectationable] instance is meant to be returned by 
 * [:expect():], eg. [:expect("Foo").toEqual("Bar"):].
 */
interface Expectationable {
  var target;
  Expectationable(var target);
}
