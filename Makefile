all: NPuzzle

NPuzzle: NPuzzle.o Helper.o
	g++ -g -o NPuzzle NPuzzle.o Helper.o
NPuzzle.o:
	g++ -c -std=c++11 -o NPuzzle.o NPuzzle.cpp
Helper.o:
	g++ -c -std=c++11 -o Helper.o Helper.cpp
run:
	./NPuzzle

clean:
	rm -f NPuzzle.o Helper.o NPuzzle *~