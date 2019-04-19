#include "cuda_runtime.h"
#include <cuda.h>
#include <stdio.h>
#include <bits/stdc++.h>
#include "Helper.h"
using namespace std;

#define BLOCK_SIZE 512
#define CUDA_FUNC __host__ __device__
#define MAX_QUEUE_SIZE 1000

class PriorityQueue {
private:

	Node heapArr[MAX_QUEUE_SIZE];
	unsigned int length;

public:

	CUDA_FUNC PriorityQueue() {
		this->length = 0;
	}


	CUDA_FUNC int compareNode(int a, int b) {

		return this->compareNode(this->heapArr[a], this->heapArr[b]);

	}

	CUDA_FUNC int compareNode(Node &left, Node &right) {
		int leftSum = left.HD + left.DT;
        int rightSum = right.HD + right.DT;
        return leftSum < rightSum;
	}

	CUDA_FUNC void swap(int a, int b) {
		Node temp = this->heapArr[a];
		this->heapArr[a] = this->heapArr[b];
		this->heapArr[b] = temp;
	}

	CUDA_FUNC void increase_val(int i, Node val) {
		// printf("asasdsa %d %d %d %d\n", i, val, this->heapArr[i], val < this->heapArr[i]);
		if(this->heapArr[i].DT != -1 && this->compareNode(val, this->heapArr[i]))
			return;
		this->heapArr[i] = val;
		// printf("insertion %d", this->heapArr[i]);
		while(i>1 && this->compareNode(i/2, i))
		{
			this->swap(i/2, i);
			i = i/2;
		}
	}

	CUDA_FUNC void insert(Node val) {
		Node NULL_NODE;
		NULL_NODE.DT = -1;
		this->length = this->length + 1;
		this->heapArr[this->length] = NULL_NODE;
		// printf("sdsfsdfdsfsd\n");
		this->increase_val(this->length, val);
		// printf("sdsfsdfdsfsd\n");

	}

	CUDA_FUNC void max_heapify(int i) {
		int left = 2*i;
		int right = 2*i+1;
		int largest = 1;
		if(left <= this->length && ! this->compareNode(left, i))
			largest = left;
		else
			largest = i;
		if(right <= this->length && ! this->compareNode(right, largest))
		    largest = right;

		if(largest != i)
		{
		    this->swap(i, largest);
		    this->max_heapify(largest);
		} 
	 }

	CUDA_FUNC Node top()
	{
		if(this->length == 0) {
			Node NULL_NODE;
			NULL_NODE.DT = -1;
			return NULL_NODE;
		}

		Node max = this->heapArr[1];

		this->heapArr[1] = this->heapArr[this->length];
		this->length--;
		max_heapify(1);
		// for(int i=0; i<this->length; i++) {
		// 	printf("%d", this->heapArr[i]);
		// }

		return max;
	}

	CUDA_FUNC int getLength() {
		return this->length;
	}

	// CUDA_FUNC void printHeap() {
	// 	for(int i=0; i<this->length; i++) {
	// 		printf("%d,%d\t", i, this->heapArr[i]);
	// 	}
	// 	printf("\n");
	// }


};

#define K 10

__global__ void parAStar(PriorityQueue *pqC) {

	int i = blockIdx.x * blockDim.x + threadIdx.x;
	// i=i+1;
	if(i < K) {
		Node val = pqC[i].top();
		printf("%d %d %d\n", i, val.DT, val.HD);
		__syncthreads();
		val = pqC[i].top();
		printf("%d %d %d\n", i, val.DT, val.HD);
		// printf("%d %d\n", i, pqC[i].top());
	}
}

int main() {

	int k = K;
	int blocks = (k / BLOCK_SIZE) + 1;
	printf("%d %d\n", blocks, BLOCK_SIZE);

	PriorityQueue pq[k];

	printf("%lu\n", sizeof(PriorityQueue));
	// printf("sdfsddsfsd");
	for(int i=0; i<k; i++) {
		pq[i] = PriorityQueue();
		for(int j=0; j<10; j++) {
			Node val;
			val.DT = i*k + j;
			val.HD = i*k + j;
			pq[i].insert(val);
		}
	}

	// for(int i=0; i<k; i++) {
	// 	pq[i].printHeap();
	// 	// printf("%d %d\n", i, pq[i].top());
	// }
	

	cudaEvent_t start_kernel, stop_kernel;
	cudaEventCreate(&start_kernel);
	cudaEventCreate(&stop_kernel);
	cudaEventRecord(start_kernel);
	// int arr[5] = {1,2,3,4,5};
	PriorityQueue *pqC;
	cudaMalloc((void**)&pqC, sizeof(PriorityQueue)*k);
	cudaMemcpy(pqC, pq, sizeof(PriorityQueue)*k, cudaMemcpyHostToDevice);
	parAStar<<<1, 32>>> (pqC);
	cudaMemcpy(pq, pqC, sizeof(PriorityQueue)*k, cudaMemcpyDeviceToHost);
	cudaEventRecord(stop_kernel);
	cudaEventSynchronize(stop_kernel);
	// cudaEventElapsedTime(&totalTime, start_kernel, stop_kernel);


	return 0;
}