This repo shows how to fuzz Java based applications with the American Fuzzy Lop (AFL) fuzzer via GCJ. GCJ is horrible.

## HOWTO:

1. Copy afl-gcc to afl-gcj, eg: cp /usr/local/bin/afl-gcc /usr/local/bin/afl-gcj
2. Make sure gcj is installed
3. Read and run the script run.sh, that's how the entire process works for me

## What's gcj?
Well, let's say a partial implementation and mostly unmaintained version of Java:

- https://en.wikipedia.org/wiki/GNU_Compiler_for_Java
- http://stackoverflow.com/questions/4647940/compile-complex-java-program-in-native-code-using-gcj#4652815
- http://stackoverflow.com/questions/4035538/is-gnus-java-compiler-gcj-dead
- Last news entry in 2009: https://gcc.gnu.org/java/ although the timeline suggests that there might be something going on https://gcc.gnu.org/develop.html#timeline

## What's a crash in Java?
As fuzzers are usually employed for native code, this question is pretty important. "Out of bound" read or writes in Java code simply do not resulting in memory corruption, but usually result in Exceptions such as IndexOutOfBoundsException. The question is what kind of behavior are we looking for? There are mainly three different scenarios that might be of interest:

1. You are fuzzing the Java Virtual Machine. In this case it might not be necessary that you call nativeCrash() of our shared object at all, but you might just be waiting for a real crash of the JVM process. However, as long as you are only feeding strings or other *data* clearly known to Java as simple types, that might be quiet hard to find. Good luck with that. If you feeding Java code, then your attack model is kind of strange, you can already execute code. This is not what we are doing here (yet).
2. You are fuzzing some Java code that uses native code (eg. JNI or CNI). If your goal is to find issues in the native code that can be triggered from the Java code you are good to go, you won't need nativeCrash() as you just wait until the native code crashes.
3. You are fuzzing pure Java code. You need to define which condition you would like Java to signalise a crash to AFL (by calling nativeCrash). Eg. whenever there is an Exception you don't expect from your code (catch all clause). For example maybe you are looking for RuntimeExceptions and Errors in your code (aka non-checked exceptions, see http://stackoverflow.com/questions/11589302/why-is-throws-exception-necessary-when-calling-a-function#11589380 for explanation). While that's nice for the robustness of your Java application, this will often never find any security issue that is more that an denial of service condition (uncaught exception). Except maybe if your Java code does a lot of strange IO (file read/writing etc.).

## What kind of fuzzing targets can we use?
The code needs to be instrumented, so jar files (eg. closed source products) are not an option for now. The hardest thing will be to compile your code with gcj, from there you're probably good to go.

## Why nativeCrash and C code?
Simply calling System.exit(134) or System.exit(-6) in Java will *not* work to make AFL detect a crash. Looking into the various options of crashing a Java program/runtime, there are open bugs/general issues we can use (memory exhaustion and such things) but they usually trigger way to slow, which would make every crash we simulate take a long time which would probably mean that crashes would result in hangs (obviously very undesired). The only other reliable and generic way of crashing Java is using some native component, usually Java Native Interface (JNI). As we are using gcj anyway the simplest method was to use CNI (Compiled Native Interface), which allows us to do exactly the same as JNI, call a function in native code (shared object). The result of this is shown in Testcase.java and crash.cc. crash.cc will simply call abort() in C and tests show that AFL is able to detect crashes with this method. This method is fast enough and works fine for now.

## Other obstacles and ideas so far:

- gcj on certain distros is old, therefore not supporting Java 1.8 or 1.9. Heck not even the command line parsing seem to be right for some of them (always complaining about -fsource parameter being in the wrong format).
- gcj doesn't play nicely with -D, therefore setting AFL_DONT_OPTIMIZE is necessary. Error was: gcj: fatal error: can't specify '-D' without '--main'

## More information
Is not available for now, as gcj is just too frustrating to make anything recently compile cleanly. If you have Java 1.5 code that's probably feasible.