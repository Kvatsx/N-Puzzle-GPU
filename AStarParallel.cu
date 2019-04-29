#include "cuda_runtime.h"
#include <cuda.h>
#include <stdio.h>
#include <bits/stdc++.h>
#include "newHelper.h"
using namespace std;

#define FINAL_STATE {{0,1,2}, {3,4,5}, {6,7,8}}
// #define FINAL_STATE {{1,2,3,4}, {5,6,7,8}, {9,10,11,12}, {13,14,15,0}}
#define BLOCK_SIZE 512
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

		return this->compareNode1(this->heapArr[a], this->heapArr[b]);

	}

	CUDA_FUNC int compareNode1(Node &left, Node &right) {

        UpdateHD(left);
        UpdateHD(right);
        // printf("left - uid %s hd %d dt %d\n", left.UID, left.HD, left.DT);
        // printf("right - uid %s hd %d dt %d\n", right.UID, right.HD, right.DT);

		int leftSum = left.HD + left.DT;
        int rightSum = right.HD + right.DT;
        // printf("comp %d\n", leftSum < rightSum);
        if(leftSum == rightSum)
            return left.HD > right.HD;
        return leftSum > rightSum;
	}

	CUDA_FUNC void swap(int a, int b) {
		Node temp = this->heapArr[a];
		this->heapArr[a] = this->heapArr[b];
		this->heapArr[b] = temp;
	}

	CUDA_FUNC void increase_val(int i, Node val) {
		// printf("asasdsa %d %d %d %d\n", i, val, this->heapArr[i], val < this->heapArr[i]);
		// if(this->heapArr[i].DT != -1 && this->compareNode1(val, this->heapArr[i]))
		// 	return;
        // printf("sdfkhsdlfkjadshlfkajdhlfkjdsh %d %d\n", i, this->length);

		this->heapArr[i] = val;
                // printf("VAL%d %d\n", val.HD, i);
		// printf("insertion %d", this->heapArr[i]);
		while(i>1 && this->compareNode(i/2, i))
		{
			this->swap(i/2, i);
			i = i/2;
		}
	}

	CUDA_FUNC void insert(Node val) {
		// Node NULL_NODE;
		// NULL_NODE.DT = -1;
		this->length = this->length + 1;
		// this->heapArr[this->length] = NULL_NODE;
		// printf("sdsfsdfdsfsd\n");
		this->increase_val(this->length, val);
		// printf("sdsfsdfdsfsd\n");
        UpdateHD(val);
        // printf("top of queue %s hd %d dt %d\n", this->heapArr[1].UID, this->heapArr[1].HD, this->heapArr[1].DT);
        // printf("current node %s hd %d dt %d\n", val.UID, val.HD, val.DT);

	}

    

	CUDA_FUNC void max_heapify(int i) {
        while(true) {

    		int left = 2*i;
    		int right = 2*i+1;
    		int largest = 1;
            // printf("dsdfgetwertrwet\n");
    		if(left <= this->length && ! this->compareNode(left, i))
    			largest = left;
    		else
    			largest = i;
    		if(right <= this->length && ! this->compareNode(right, largest))
    		    largest = right;

    		if(largest != i) {
    		    this->swap(i, largest);
    		    i = largest;
    		}
            else {
                break;
            }
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

		this->max_heapify(1);
		// for(int i=0; i<this->length; i++) {
		// 	printf("%d", this->heapArr[i]);
		// }
        
		return max;
	}

	CUDA_FUNC int getLength() {
		return this->length;
	}

	CUDA_FUNC void printHeap() {
		for(int i=0; i<this->length; i++) {
			printf("(%d : %s)\n", i, this->heapArr[i].UID);
		}
		printf("\n");
	}


};

/*
* Updating the HD of the passed Node
*/
CUDA_FUNC void UpdateHD(Node& node) {

    int finalState[N][N] = FINAL_STATE;

    if(node.HD > -1) {
        return;
    }

    // for(int i=0; i<N; i++) {
    //     for(int j=0; j<N; j++) {
    //         cout << node.Data[i][j] << " ";
    //     }
    //     cout << endl;
    // }

    int nodeArr[N*N], finalArr[N*N];
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            int pos = i*N + j;
            // cout << pos << " " << node.Data[i][j] << endl;
            nodeArr[node.Data[i][j]] = pos;
            finalArr[finalState[i][j]] = pos;
            // cout << node.Data[i][j] << " " << pos << endl;
            // int b = getIndexInState(pos, node.Data);
            // int g = getIndexInState(pos, finalState);
            // sum += abs(b % N - g % N);
            // sum += abs(b / N - g / N);
        }
    }

    int HDvalue = 0;
    for(int i=1; i<N*N; i++){
        int b = nodeArr[i];
        int g = finalArr[i];
        HDvalue += abs(b % N - g % N);
        HDvalue += abs(b / N - g / N);
    }
    node.HD = HDvalue;
}

/* 
 * Fill all required values of the struct
 */
CUDA_FUNC void Fill(Node * node, int dt, int hd, int data[N][N], Node * link, int parentID) {
    node->DT = dt;
    node->HD = -1;
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            node->Data[i][j] = data[i][j];
            node->UID[2*(N*i + j)] = data[i][j] + '0';
            node->UID[2*(N*i + j)+1] = ' ';
        }
    }
    node->UID[2*N*N] = '\0';
    node->Link = link;
    node->parentID = parentID;
}

/*
 * This function empty tile in the node.
 * Returns: Add X, Y coordinate of 0 Tile in Array 'arr'
 */
CUDA_FUNC void FindZeros(int data[N][N], int * x, int * y) {
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            if (data[i][j] == 0) {
                *x = i;
                *y = j;
                return;
            }
        }
    }
}

/*
 * DeepcopyData: Copy Data variable in same size array.
 * node: Original Node.
 * copy: Copy data.
 */
CUDA_FUNC void DeepcopyData(Node * node, int copy[N][N]) {
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            copy[i][j] = node->Data[i][j];
        }
    }
}


/* 
 * Find all neighbours of the Node,
 * Next possible state of the node.
 * Case 1: Corners of the Grid.
 * Case 2: When 0 is on the Edge of the grid
 * Case 3: When 0 in anywhere except above above possible cases
 * Return: Add all Neighbours in 2nd Argument
 */
CUDA_FUNC int GetNeighbours(Node * currentNode) {
    Node * neighbours;
    neighbours = (Node *) malloc(sizeof(Node) * 4);
    int x, y, neighbours_count = 0;
    FindZeros(currentNode->Data, &x, &y);
    // cout << "Zero Coordinates\nX: " << x << "\tY: " << y << endl;
    // printf("Printing Current Node in GetNeighbours: HD %d DT %d UID %s Parent %d\n ", currentNode->HD, currentNode->DT, currentNode->UID, currentNode->parentID);
    // Case 1: Corner 1, 2, 3, 4
    if (x == 0 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 3) {
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        // neighbours[2] = {0};
        // neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == 0 && y == N-1) {
        // Need to repeat same for rest of the conditions
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 3) {
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        // neighbours[2] = {0};
        // neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == N-1 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 3);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        // neighbours[2] = {0};
        // neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (x == N-1 && y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 3);
            // printf("This is my house %d %d %s\n", n2.DT, n2.HD, n2.UID);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        // neighbours[2] = {0};
        // neighbours[3] = {0};
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    // Case 2: Edge 1, 2, 3, 4
    else if (x == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }  

        if (currentNode->parentID != 3) { 
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n3;
            Fill(&n3, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[2] = n3;
            neighbours_count+=1;
        }
        // neighbours[3] = {0};    
        currentNode->Link = neighbours;
        // toString(currentNode);

    }
    else if (y == 0) {


        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 3);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }

        if (currentNode->parentID != 3) {
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n3;
            Fill(&n3, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[2] = n3;
            neighbours_count+=1;
        }   
        // neighbours[3] = {0};    
        currentNode->Link = neighbours;
        // toString(currentNode);

    }
    else if (x == N-1) {

        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID !=2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }
       
        if (currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        
        if (currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n3;
            Fill(&n3, currentNode->DT+1, -1, Temp, NULL, 3);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[2] = n3;
            neighbours_count+=1;
        }
       
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    else if (y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if (currentNode->parentID != 3) {
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if(currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }
        
        if(currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n3;
            Fill(&n3, currentNode->DT+1, -1, Temp, NULL, 3);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[2] = n3;
            neighbours_count+=1;
        }
        currentNode->Link = neighbours;
        // toString(currentNode);
    }
    // Case 3: Tile 0 Anywhere, except above possible location.
    else {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);

        neighbours[0] = {0};
        neighbours[1] = {0};
        neighbours[2] = {0};
        neighbours[3] = {0};

        if(currentNode->parentID != 3) {
            Temp[x][y] = Temp[x+1][y];
            Temp[x+1][y] = 0;
            Node n1;
            Fill(&n1, currentNode->DT+1, -1, Temp, NULL, 1);
            Temp[x+1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[0] = n1;
            neighbours_count+=1;
        }

        if(currentNode->parentID != 4) {
            Temp[x][y] = Temp[x][y-1];
            Temp[x][y-1] = 0;
            Node n2;
            Fill(&n2, currentNode->DT+1, -1, Temp, NULL, 2);
            Temp[x][y-1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[1] = n2;
            neighbours_count+=1;
        }

        if(currentNode->parentID != 1) {
            Temp[x][y] = Temp[x-1][y];
            Temp[x-1][y] = 0;
            Node n3;
            Fill(&n3, currentNode->DT+1, -1, Temp, NULL, 3);
            Temp[x-1][y] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[2] = n3;
            neighbours_count+=1;
        }

        if(currentNode->parentID != 2) {
            Temp[x][y] = Temp[x][y+1];
            Temp[x][y+1] = 0;
            Node n4;
            Fill(&n4, currentNode->DT+1, -1, Temp, NULL, 4);
            Temp[x][y+1] = Temp[x][y];
            Temp[x][y] = 0;
            neighbours[3] = n4;
            neighbours_count+=1;
        }

        currentNode->Link = neighbours;
        // toString(currentNode);
    }

    return neighbours_count;
}

CUDA_FUNC int checkSolution(Node * node, int *FinalState) {
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            if (node->Data[i][j] != FinalState[i*N+j]) {
                return 1;
            }
        }
    }
    return 0;
}

#define K 15
__device__ int continueWork = 1;
__device__ int allQueueEmpty = 0;

__global__ void parAStar(PriorityQueue *pqC, int *FinalState, int startStateHeuristic) {

    int i = blockIdx.x * blockDim.x + threadIdx.x;
    // printf("(%d) ", i);
    int count = 0;

    while(continueWork) {

    	count+=1;
        // printf("This is count of %d value %d\n", i, count);

    	if(i < K) {
            // printf("fdsdfgfd %d\n", pqC[i].getLength());
    		Node val = pqC[i].top();
            // printf("Extracted node in thread: i:%d DT:%d HD:%d UID:%s\n", i, val.DT, val.HD, val.UID);
            if (val.DT != -1) {
                // printf("Extracted node in thread: i:%d DT:%d HD:%d UID:%s\n", i, val.DT, val.HD, val.UID);
                int matchFinal = checkSolution(&val, FinalState);
                if (matchFinal == 0) {
                    printf("Done the solution state\n");
                    continueWork = 0;
                }
                // printf("sdfkhsdlfkjadshlfkajdhlfkjdsh\n");
                // __syncthreads();
                // printf("Generated Neighbours:\n");
    			int count_neighbours = GetNeighbours(&val);
    			for(int j=0; j<4; j++) {
                    UpdateHD(val.Link[j]);
                    if (val.Link[j].DT != 0/* && val.Link[j].DT + val.Link[j].HD <= startStateHeuristic*/) {
                        // printf("UID - %s, HD - %d, DT - %d\n", val.Link[j].UID, val.Link[j].HD, val.Link[j].DT);
                        pqC[(i*4+j)%K].insert(val.Link[j]);
                        // printf("Print neighbour UID %s j %d inK %d HD %d DT %d\n", val.Link[j].UID, j, (i*4+j)%K, val.Link[j].HD, val.Link[j].DT);
                        // printf("True or False %d\n", val.Link[j].parentID == 0);
                  
                    }
                }
                // printf("sdfkhsdlfkjadshlfkajdhlfkjdsh\n");
    		}
            // printf("(%d, %d)\n", i, continueWork);
            __syncthreads();
    	}
        __syncthreads();
    }
}

int emptyPriorityQueue(PriorityQueue pq[K]) {
    for (int i=0; i<K; i++) {
        // printf("Length of queue %d %d\n", pq[i].getLength(), i);
        if (pq[i].getLength() != 0) {
            // pq[i].printHeap();
            return 0;
        }
    }
    return 1;
}

// #define K 320
int main() {



	int Start[N][N] = {
        {4, 5, 1},
        {0, 3, 2},
        {6, 8, 7}
    };

    // int Start[N][N] = {
    //     {12, 1, 10, 2}, 
    //     {7, 11, 4, 14}, 
    //     {5, 0, 9, 15},
    //     {8, 13, 6, 3}
    // };


    //     int Start[N][N] = {
    //     {1, 2, 6, 3}, 
    //     {4, 5, 7, 0}, 
    //     {8, 9, 10, 11},
    //     {12, 13, 14, 15}
    // };


    int FinalState[N][N] = FINAL_STATE;
    Node root, final;
    Fill(&root, 0, 0, Start, NULL, -1);
    Fill(&final, 0, 0, FinalState, NULL, -1);
    UpdateHD(root);
    // printf("root.HD + root.DT = %d\n", root.HD + root.DT);

	int k = K;
	// int blocks = (k / BLOCK_SIZE) + 1;
	// printf("%d %d\n", blocks, BLOCK_SIZE);

	PriorityQueue pq[k];

	// printf("%lu\n", sizeof(PriorityQueue));
	// printf("sdfsddsfsd");
	for(int i=0; i<k; i++) {
		pq[i] = PriorityQueue();
	}

	// printf("%d %d %s\n", root.DT, root.HD, root.UID);
	pq[0].insert(root);

	// int arr[5] = {1,2,3,4,5};
	PriorityQueue *pqC;
    int *FinalState_device;
    int Reached[K];
    for(int i=0; i<K; Reached[i++]=0);
    int *Reached_device;

	cudaMalloc((void**)&pqC, sizeof(PriorityQueue)*k);
	
    cudaMalloc((void**)&FinalState_device, N*N*sizeof(int));
    
    cudaMalloc((void**)&Reached_device, K*(sizeof(int)));
    
    cudaMemcpy(pqC, pq, sizeof(PriorityQueue)*k, cudaMemcpyHostToDevice);   
    float runningTime = 0;
    // int counter = 0;
    
        cudaMemcpy(FinalState_device, FinalState, N*N*sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(Reached_device, Reached,K*sizeof(int), cudaMemcpyHostToDevice);
        
        // printf("HELLO");

        cudaEvent_t start_kernel, stop_kernel;
        cudaEventCreate(&start_kernel);
        cudaEventCreate(&stop_kernel);
        cudaEventRecord(start_kernel);
        parAStar<<<1, K>>> (pqC, FinalState_device, root.HD + root.DT);

        cudaEventRecord(stop_kernel);
        cudaEventSynchronize(stop_kernel);
        float totalTime;
        cudaEventElapsedTime(&totalTime, start_kernel, stop_kernel);
        //printf("Tme %f\n", totalTime);
        runningTime += totalTime;
        

    cudaMemcpy(pq, pqC, sizeof(PriorityQueue)*k, cudaMemcpyDeviceToHost);

    printf("\n\n\n\nFinal Running time %0.4f\n", runningTime);


	return 0;
}