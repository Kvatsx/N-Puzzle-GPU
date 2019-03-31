all: NPuzzle

NPuzzle: NPuzzle.o Helper.o
	g++ -o NPuzzle NPuzzle.o Helper.o -g 
	./NPuzzle

clean:
	rm -f NPuzzle.o Helper.o NPuzzle *~