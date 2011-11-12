/**
* An ExpectationableSelector is a function that, given 
* a target object, can return either:
*
*  - an instance of an Expectationable class, initialized with the 
*    target object, so we can call the functions that the Expectationable 
*    class provides on the target object, eg. toEqual()
*
*  - or null to indicate that we don't want to run expectations on 
*    the given target, so another ExpectationableSelector 
*    should be checked to return an Expectationable.
*/
typedef Expectationable ExpectationableSelector(var target);
