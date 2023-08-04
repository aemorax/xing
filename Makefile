all: out/tests

out/tests: out/tests.c
	gcc out/tests.c -o out/tests -Iout -lhl