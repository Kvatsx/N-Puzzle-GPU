#ifndef HELPER_H
#define HELPER_H

// Size of the Grid
#define N 4
#define BlockSize 32;

/* 
 * Structure of the node
 * UID: Denotes unique id of the Node, will be used to 
 * check whether a node is visited or not.
 * DT: Denotes Distance from the root node.
 * HD: Denotes Heeuristic Distance of Current node from Resultant Node
 * Data: Store Arrangement of the tiles in the data.
 * Link: Stores Next possible states.
*/
struct Node {
    char UID[N*N*2];
    // string UID = "";
    int DT;
    int HD;
    int Data[N][N];
    Node * Link;
 //    bool operator<(const Node &o) {
	//     int finalState[N][N] = FINAL_STATE;
	//     int tSum = UpdateHD(this, finalState) + DT;
	//     int oSum = UpdateHD(o, finalState) + o.DT;
	//     return tSum < oSum;
	// }
};

void toString(Node * node);

void Fill(Node * node, int dt, int hd, int data[N][N], Node * link);

void DeepcopyData(Node * node, int copy[N][N]);

void UpdateHD(Node& node, int FinalState[N][N]);

void FindZeros(int data[N][N], int * x, int * y);

void temp_display(int data[N][N]);

void GetNeighbours(Node * currentNode);

int checkSolution(Node * node, int FinalState[N][N]);


#endif