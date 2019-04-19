#include <cuda_runtime.h>
#include <cuda.h>
#include <stdio.h>

#define BLOCK_SIZE 512

__global__ void parAStar(int *Va) {

	int i = blockIdx.x * blockDim.x + threadIdx.x;
	// i=i+1;
	printf("%d\n", Va[i]);
}

int main() {

	int k = 1000;
	int blocks = (k / BLOCK_SIZE) + 1;
	printf("%d %d\n", blocks, BLOCK_SIZE);
	
	// cudaEvent_t start_kernel, stop_kernel;
	// cudaEventCreate(&start_kernel);
	// cudaEventCreate(&stop_kernel);
	// cudaEventRecord(start_kernel);
	int arr[5] = {1,2,3,4,5};
	int* Va;
	cudaMalloc((void**)&Va, sizeof(int)*5);
	cudaMemcpy(Va, arr, sizeof(int)*5, cudaMemcpyHostToDevice);
	parAStar<<<1, 32>>> (Va);
	cudaMemcpy(arr, Va, sizeof(int)*5, cudaMemcpyDeviceToHost);
	// cudaEventRecord(stop_kernel);
	// cudaEventSynchronize(stop_kernel);
	// cudaEventElapsedTime(&totalTime, start_kernel, stop_kernel);


	return 0;
}