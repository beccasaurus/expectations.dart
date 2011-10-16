#import("../src/expectations.dart");

main() {
  var text = "foo";

  // Without Expectations
  Expect.equals("foo", text);

  // With Expectations
  expect(text).toEqual("foo");
}
