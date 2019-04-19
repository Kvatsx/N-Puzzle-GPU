all: clean compile run

cc: clean compile

pas:
	rm -f priorityQueue *~
	nvcc -o priorityQueue priorityQueue.cu 
	./priorityQueue


cc-cuda: clean-cuda compile-cuda

cuda: clean-cuda compile-cuda run-cuda

compile: NPuzzle.o Helper.o
	g++ -g -o NPuzzle NPuzzle.o Helper.o
NPuzzle.o:
	g++ -c -std=c++11 -o NPuzzle.o NPuzzle.cpp
Helper.o:
	g++ -c -std=c++11 -o Helper.o Helper.cpp

compile-cuda: NPuzzle-cuda.o Helper-cuda.o
	nvcc -g -o NPuzzle-cuda NPuzzle-cuda.o Helper-cuda.o
NPuzzle-cuda.o:
	nvcc -c -std=c++11 -o NPuzzle-cuda.o NPuzzle.cu
Helper-cuda.o:
	nvcc -c -std=c++11 -o Helper-cuda.o Helper.cu

run:
	./NPuzzle

run-cuda:
	./NPuzzle-cuda

clean:
	rm -f NPuzzle.o Helper.o NPuzzle *~

clean-cuda:
	rm -f NPuzzle-cuda NPuzzle-cuda.o Helper-cuda.o *~