#library("spec");
class SpecDescribe {
  static List<Function> _beforeFunctions;
  static List<Function> _afterFunctions;
  static void beforeRun(Function callback) => _beforeFunctions.add(callback);
  static void afterRun(Function callback) => _afterFunctions.add(callback);
  Spec spec;
  SpecDescribe parent;
  String subject;
  Function fn;
  List<SpecExample> examples;
  List<SpecDescribe> describes;
  List befores;
  List afters;
  bool _evaluatedFn;
  List<SpecDescribe> _parentDescribes;
  SpecDescribe([Spec spec = null, SpecDescribe parent = null, String subject = null, Function fn = null]) {
    if (_beforeFunctions == null) _beforeFunctions = new List<Function>();
    if (_afterFunctions == null)  _afterFunctions = new List<Function>();
    this.spec      = spec;
    this.subject   = subject;
    this.fn        = fn;
    this.examples  = new List<SpecExample>();
    this.describes = new List<SpecDescribe>();
    this.befores   = new List();
    this.afters    = new List();
    this.parent    = parent;
  }
  void evaluate() {
    if (_evaluatedFn != true) {
      _evaluatedFn = true;
      if (fn != null) fn();
    }
  }
  List<SpecDescribe> get parentDescribes() {
    if (_parentDescribes == null) {
      List<SpecDescribe> tempDescribes = new List<SpecDescribe>();
      SpecDescribe       currentParent = parent;
      while (currentParent != null) {
        tempDescribes.add(currentParent);
        currentParent = currentParent.parent;
      }
      _parentDescribes = new List<SpecDescribe>();
      var times = tempDescribes.length;
      for (int i = 0; i < times; i++)
        _parentDescribes.add(tempDescribes.removeLast());
    }   
    return _parentDescribes;
  }
  void runBefores() {
    befores.forEach((fn) => fn());
  }
  void runAfters() {
    afters.forEach((fn) => fn());
  }
  void run() {
    _beforeFunctions.forEach((fn) => fn(this));
    examples.forEach((example) {
      parentDescribes.forEach((parent) => parent.runBefores());
      runBefores();
      example.run();
      runAfters();
      parentDescribes.forEach((parent) => parent.runAfters());
    });
    describes.forEach((desc) => desc.run());
    _afterFunctions.forEach((fn) => fn(this));
  }
}
class SpecExample {
  static List<Function> _beforeFunctions;
  static List<Function> _afterFunctions;
  static void beforeRun(Function callback) => _beforeFunctions.add(callback);
  static void afterRun(Function callback) => _afterFunctions.add(callback);
  SpecDescribe describe;
  static bool raiseExceptions; // UNTESTED! TODO
  String name;
  Function fn;
  String result;
  Exception exception;
  SpecExample([SpecDescribe describe, String name = null, Function fn = null]) {
    if (_beforeFunctions == null) _beforeFunctions = new List<Function>();
    if (_afterFunctions == null)  _afterFunctions = new List<Function>();
    this.describe   = describe;
    this.name       = name;
    this.fn         = fn;
  }
  String get pendingReason() {
    if (result == SpecExampleResult.pending && exception is SpecPendingException)
      return exception.message;
    else
      return null;
  }
  bool get passed()  => result == SpecExampleResult.passed;
  bool get failed()  => result == SpecExampleResult.failed;
  bool get error()   => result == SpecExampleResult.error;
  bool get pending() => result == SpecExampleResult.pending;
  void run() {
    _beforeFunctions.forEach((fn) => fn(this));
    _runFunction();
    _afterFunctions.forEach((fn) => fn(this));
  }
  void _runFunction() {
    if (fn == null) {
      result = SpecExampleResult.pending;
    } else {
      if (SpecExample.raiseExceptions == true) {
        fn();
        result = SpecExampleResult.passed;
      } else {
        try {
          fn();
          result = SpecExampleResult.passed;
        } catch (ExpectException ex) {
          result    = SpecExampleResult.failed;
          exception = ex;
        } catch (SpecPendingException ex) {
          result    = SpecExampleResult.pending;
          exception = ex;
        } catch (Exception ex) {
          result    = SpecExampleResult.error;
          exception = ex;
        }
      }
    }
  }
}
class SpecExampleResult {
  static final String passed  = "Passed";
  static final String pending = "Pending";
  static final String failed  = "Failed";
  static final String error   = "Error";
}
interface SpecFormattable {
  void header();
  void footer();
  void beforeSpec(Spec spec);
  void afterSpec(Spec spec);
  void beforeDescribe(SpecDescribe describe);
  void afterDescribe(SpecDescribe describe);
  void beforeExample(SpecExample describe);
  void afterExample(SpecExample describe);
}
class SpecFormatter implements SpecFormattable {
  static Map<String,String> _colors;
         bool               _colorize;
         Function           _loggingFunction;
  static Map<String,String> get colors() {
    if (_colors == null)
      _colors = {
        "white":  "\x1b\x5b;0;37m",
        "red":    "\x1b\x5b;0;31m",
        "green":  "\x1b\x5b;0;32m",
        "yellow": "\x1b\x5b;0;33m"
      };
    return _colors;
  }
  void header(){}
  void footer(){}
  void beforeSpec(Spec spec){}
  void afterSpec(Spec Spec){}
  void beforeDescribe(SpecDescribe describe){}
  void afterDescribe(SpecDescribe describe){}
  void beforeExample(SpecExample example){}
  void afterExample(SpecExample example){}
  bool printToStdout;
  String get indentString() => "  ";
  String get colorReset() => "\x1b\x5b;0;37m";
  bool get colorize() {
    if (_colorize == null) _colorize = true;
    return (_colorize == true);
  }
  set colorize(bool value) => _colorize = value;
  void logger(Function fn) {
    _loggingFunction = fn;
  }
  void write(String text, [int indent = 0, String color = null]) {
    String result = _indent(indent, text);
    if (colorize == true)
      result = _colorizeText(result, color);
    if (printToStdout != false)
      print(result);
    if (_loggingFunction != null)
      _loggingFunction(result + "\n");
  }
  String _colorizeText([String text = null, String color = null]) {
    if (color == null)
      return text;
    else
      return "${colors[color]}${text}${colorReset}";
  }
  String _indent(int indent, String text) {
    String prefix = "";
    for (int i = 0; i < indent; i++)
      prefix += indentString;
    return prefix + text;
  }
}
class SpecPendingException implements Exception {
  String message;
  SpecPendingException(this.message);
  String toString() => message;
}
class Spec {
  static final VERSION = "0.1.0";
  static List<Function> _beforeFunctions;
  static List<Function> _afterFunctions;
  static void beforeRun(Function callback) => _beforeFunctions.add(callback);
  static void afterRun(Function callback) => _afterFunctions.add(callback);
  List<SpecDescribe> describes;
  List<SpecDescribe> _currentDescribes;
  Spec() {
    if (_beforeFunctions == null) _beforeFunctions = new List<Function>();
    if (_afterFunctions == null)  _afterFunctions = new List<Function>();
    describes         = new List<SpecDescribe>();
    _currentDescribes = new List<SpecDescribe>();
    spec();
  }
  void spec() {}
  SpecDescribe describe([String subject = null, Function fn = null]) {
    SpecDescribe parent   = _currentDescribes.length == 0 ? null : _currentDescribes.last();
    SpecDescribe describe = new SpecDescribe(spec: this, subject: subject, fn: fn, parent: parent);
    if (_currentDescribes.length == 0)
      describes.add(describe);
    else
      _currentDescribes.last().describes.add(describe);
    _currentDescribes.addLast(describe);
    describe.evaluate();
    _currentDescribes.removeLast();
    return describe;
  }
  SpecExample it([String name = null, Function fn = null]) {
    SpecDescribe desc = _getCurrentDescribe("it");
    SpecExample example = new SpecExample(describe: desc, name: name, fn: fn);
    desc.examples.add(example);
    return example;
  }
  void pending([String message = "PENDING"]) {
    throw new SpecPendingException(message);
  }
  SpecDescribe _getCurrentDescribe([String callerFunctionName = null]) {
    SpecDescribe currentDescribe = _currentDescribes.last();
    if (currentDescribe != null) {
      return currentDescribe;
    } else {
      if (callerFunctionName != null)
        throw new UnsupportedOperationException("it${callerFunctionName} cannot be used before calling describe()");
    }
  }
  void before([Function fn = null]) {
    _getCurrentDescribe("before").befores.add(fn);
  }
  void after([Function fn = null]) {
    _getCurrentDescribe("after").afters.add(fn);
  }
  void run() {
    _beforeFunctions.forEach((fn) => fn(this));
    describes.forEach((desc) => desc.run());
    _afterFunctions.forEach((fn) => fn(this));
  }
}
class SpecDocFormatter extends SpecFormatter implements SpecFormattable {
  int _describeDepth;
  List<SpecExample> examples;
  SpecDocFormatter() {
    examples = new List<SpecExample>();
    _describeDepth = 0;
  }
  Collection<SpecExample> get passedExamples()  => examples.filter((ex) => ex.passed);
  Collection<SpecExample> get failedExamples()  => examples.filter((ex) => ex.failed);
  Collection<SpecExample> get errorExamples()   => examples.filter((ex) => ex.error);
  Collection<SpecExample> get pendingExamples() => examples.filter((ex) => ex.pending);
  void header() {
    write("~ Spec.dart ${Spec.VERSION} ~\n");
  }
  void beforeDescribe(SpecDescribe describe) {
    write(describe.subject, indent: _describeDepth);
    ++_describeDepth;
  }
  void afterDescribe(SpecDescribe describe) {
    --_describeDepth;
  }
  void afterExample(SpecExample example) {
    if (examples == null)
      examples = new List<SpecExample>();
    examples.add(example);
    String pendingString = "";
    if (example.pending == true)
      if (example.pendingReason == null)
        pendingString = "[PENDING] ";
      else
        pendingString = "[${example.pendingReason}] ";
    write(pendingString + example.name, indent: _describeDepth, color: colorForExample(example));
  }
  String colorForExample(SpecExample example) {
    switch (example.result) {
      case SpecExampleResult.passed:  return "green";
      case SpecExampleResult.failed:  return "red";
      case SpecExampleResult.error:   return "red";
      case SpecExampleResult.pending: return "yellow";
      default: return "white";
    }
  }
  void separator() {
    write("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
  }
  void footer() {
    if (failedExamples.length > 0 || errorExamples.length > 0 || pendingExamples.length > 0) separator();
    failedSummary();
    errorSummary();
    pendingSummary();
    summary();
  }
  void summary() {
    String color   = "green";
    String summary = "\n${examples.length} Examples, ${failedExamples.length} Failures";
    if (errorExamples.length > 0) {
      summary += ", ${errorExamples.length} Errors";
      color = "red";
    }
    if (pendingExamples.length > 0) {
      summary += ", ${pendingExamples.length} Pending";
      if (color == "green")
        color = "yellow";
    }
    write(summary, color: color);
  }
  void failedSummary() {
    if (failedExamples.length > 0) {
      write("\nFailures:");
      failedExamples.forEach((example) {
        write("");
        write("${example.describe.subject} ${example.name}", indent: 1, color: colorForExample(example));
        write("Exception: ${example.exception}", indent: 2);
      });
    }
  }
  void errorSummary() {
    if (errorExamples.length > 0) {
      write("\nErrors:");
      errorExamples.forEach((example) {
        write("");
        write("${example.describe.subject} ${example.name}", indent: 1, color: colorForExample(example));
        write("Exception: ${example.exception}", indent: 2, color: colorForExample(example));
      });
    }
  }
  void pendingSummary() {
    if (pendingExamples.length > 0) {
      write("\nPending:\n");
      pendingExamples.forEach((example) {
        String pendingReason = (example.pendingReason != null) ? " [${example.pendingReason}]" : null;
        write("${example.describe.subject} ${example.name}${pendingReason}", indent: 1, color: colorForExample(example));
      });
    }
  }
}
class Specs {
  static SpecFormatter formatter;
  static bool _formatterCallbacksSetup;
  static void run(List<Spec> specs) {
    _setupFormatterCallbacks();
    if (formatter == null)
      formatter = new SpecDocFormatter();
    formatter.header();
    specs.forEach((spec) => spec.run());
    formatter.footer();
  }
  static _setupFormatterCallbacks() {
    if (_formatterCallbacksSetup != true) {
      _formatterCallbacksSetup = true;
      Spec.beforeRun((spec) => Specs.formatter.beforeSpec(spec));
      Spec.afterRun((spec) => Specs.formatter.afterSpec(spec));
      SpecDescribe.beforeRun((desc) => Specs.formatter.beforeDescribe(desc));
      SpecDescribe.afterRun((desc) => Specs.formatter.afterDescribe(desc));
      SpecExample.beforeRun((ex) => Specs.formatter.beforeExample(ex));
      SpecExample.afterRun((ex) => Specs.formatter.afterExample(ex));
    }
  }
}
