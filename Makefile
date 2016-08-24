Testcase:  Testcase.o crash.o 
	afl-gcj -o Testcase \
		Testcase.o crash.o -lstdc++ --main=Testcase

Testcase.o:  Testcase.class
	afl-gcj -c Testcase.class

Testcase.class: Testcase.java
	afl-gcj -C Testcase.java

Testcase.h: Testcase.class
	gcjh -cp . Testcase

crash.o: Testcase.h crash.cc
	g++ -c crash.cc

clean:
	rm -f Testcase Testcase.o crash.o Testcase.class Testcase.h
