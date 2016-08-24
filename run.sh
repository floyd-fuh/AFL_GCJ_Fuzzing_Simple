set -x
mkdir input
echo "AAA" > input/A
#need AFL_DONT_OPTIMIZE, as gcj doesn't play nicely with -D
#gcj: fatal error: can't specify '-D' without '--main'
export AFL_DONT_OPTIMIZE=TRUE
make clean
make
./Testcase < input/A
echo "last command exit code: $?"
afl-fuzz -i input/ -o output -m 100 ./Testcase
