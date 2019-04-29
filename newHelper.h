#ifndef HELPER_H
#define HELPER_H

// Size of the Grid
#define N 3

#define CUDA_FUNC __host__ __device__

/* 
 * Structure of the node
 * UID: Denotes unique id of the Node, will be used to 
 * check whether a node is visited or not.
 * DT: Denotes Distance from the root node.
 * HD: Denotes Heeuristic Distance of Current node from Resultant Node
 * Data: Store Arrangement of the tiles in the data.
 * parentID: Stores the id of the parent that created this node 1->TOP, 2->Right, 3->Bottom, 4->Left
 * Link: Stores Next possible states.
*/
struct Node {
    char UID[2*N*N+1];
    int DT;
    int HD;
    int Data[N][N];
    int parentID;
    Node * Link;
 //    bool operator<(const Node &o) {
	//     int finalState[N][N] = FINAL_STATE;
	//     int tSum = UpdateHD(this, finalState) + DT;
	//     int oSum = UpdateHD(o, finalState) + o.DT;
	//     return tSum < oSum;
	// }
};

CUDA_FUNC void toString(Node * node);

CUDA_FUNC void Fill(Node * node, int dt, int hd, int data[N][N], Node * link);

CUDA_FUNC void DeepcopyData(Node * node, int copy[N][N]);

CUDA_FUNC void UpdateHD(Node& node);

CUDA_FUNC void FindZeros(int data[N][N], int * x, int * y);

CUDA_FUNC void temp_display(int data[N][N]);

CUDA_FUNC int GetNeighbours(Node * currentNode);

CUDA_FUNC int checkSolution(Node * node, int FinalState[N][N]);

#endif