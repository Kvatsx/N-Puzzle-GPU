all: clean compile run

cc: clean compile

pas: clean
	rm -f priorityQueue *~
	nvcc -o priorityQueue priorityQueue.cu 
	./priorityQueue

1pas: clean
	rm -f AStarParallel *~
	nvcc -std=c++11 -o AStarParallel AStarParallel.cu 
	./AStarParallel


cc-cuda: clean-cuda compile-cuda

cuda: clean-cuda compile-cuda run-cuda

compile: NPuzzle.o Helper.o
	g++ -g -o NPuzzle NPuzzle.o Helper.o
NPuzzle.o:
	g++ -c -std=c++11 -o NPuzzle.o NPuzzle.cpp
Helper.o:
	g++ -c -std=c++11 -o Helper.o Helper.cpp

compile-cuda: priorityQueue.o Helper-cuda.o
	nvcc -g -o priorityQueue priorityQueue.o Helper-cuda.o
priorityQueue.o:
	nvcc -c -std=c++11 -o priorityQueue.o priorityQueue.cu
Helper-cuda.o:
	nvcc -c -std=c++11 -o Helper-cuda.o Helper.cu

run:
	./NPuzzle

run-cuda:
	./priorityQueue

clean:
	rm -f NPuzzle.o Helper.o NPuzzle *~

clean-cuda:
	rm -f priorityQueue priorityQueue.o Helper-cuda.o *~