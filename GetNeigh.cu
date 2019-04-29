#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
// #include <math.h>
#include <ctime>
#include <bits/stdc++.h> 
#include "Helper.h"
#include <cmath>

using namespace std;

#define BlockSize 32;

__global__ void findZero(int * d_data, unsigned int * d_xy) {
    // printf("%d\t", d_data[threadIdx.x]);
    if (d_data[threadIdx.x] == 0 && threadIdx.x < N*N) {
        d_xy[0] = threadIdx.x;
    }
}

void find_my_neigh(Node& node) {
    int * d_data;
    unsigned int * d_xy;
    cudaMalloc((void**) &d_data, sizeof(int)*N*N);
    cudaMalloc((void**) &d_xy, sizeof(unsigned int));
    cudaMemcpy(d_data, node.Data, sizeof(int)*N*N , cudaMemcpyHostToDevice);
    
    findZero<<<1, 32>>>(d_data, d_xy); 
    unsigned int * xy;
    xy = (unsigned int *) malloc(sizeof(unsigned int)); 

    cudaMemcpy(xy, d_xy, sizeof(unsigned int), cudaMemcpyDeviceToHost);
    // cout << "xy: " << xy[0] << endl;
    int x = (int) floor(xy[0] / N);
    int y = (int)xy[0] - x*N;
    // cout << "x: " << x << " y: " << y << endl;
    
    // Case 1: Corner 1, 2, 3, 4
    if (x == 0 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == 0 && y == N-1) {
        // Need to repeat same for rest of the conditions
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == N-1 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == N-1 && y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    // Case 2: Edge 1, 2, 3, 4
    else if (x == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n3;
        Fill(&n3, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};    
        currentNode->Link = neighbours;
        // toString(currentNode);

    }
    else if (y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n3;
        Fill(&n3, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};    
        currentNode->Link = neighbours;
        // toString(currentNode);

    }
    else if (x == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    // Case 3: Tile 0 Anywhere, except above possible location.
    else {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n1;
        Fill(&n1, currentNode->DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode->DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;

        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n4;
        Fill(&n4, currentNode->DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[3] = n4;
        currentNode->Link = neighbours;
        // toString(currentNode);
    }

    return;
}

// class GetNeighbours {
// public:

    
// };

int main() {
    int Start[][N] = {
        {3, 1, 2, 5}, {4, 0, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}
    };
    Node root;
    Fill(&root, 0, 0, Start, NULL);
    // GetNeighbours gn;
    find_my_neigh(root);
}
