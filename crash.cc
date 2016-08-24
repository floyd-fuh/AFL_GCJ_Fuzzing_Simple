//CNI example taken from https://gcc.gnu.org/java/cni-2.txt
#include <gcj/cni.h>
#include "Testcase.h"
//#include <java/io/PrintStream.h>
//#include <java/lang/System.h>
//#include <java/lang/String.h>
#include <stdlib.h>
//#include <stdio.h>
void Testcase::nativeCrash()
{
  // Due to the new exception-handling code implemented
  // in gcc version 3.0, the following line will fail
  // with an error about mixing exception types between
  // C++ and Java.  Factoring this code out into a
  // seperate function that does not include any Java
  // code solves the problem.
  //  cout << "Hello, C++" << endl;
  //callSTLcode();
  
  // In version 2.96, the following line causes a link error 
  // for a missing typeinfo unless this file is compiled 
  // with '-fno-rtti'.  This is corrected in version 3.0.
  
  //java::lang::System::out->println();

  //puts("Hello, I'm a shared library");
  abort();
}

