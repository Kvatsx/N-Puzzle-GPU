// Kaustav Vats (2016048)
// Anubhav Jaiswal (2016014)
// Arshdeep Singh (2016018)

#include <iostream>
#include <cstring>
using namespace std;

// Size of the Grid
#define N 3     

/*
 * Notes:
 * 1. 0 is denoted as blank tile.
 */


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
    char UID[N*N+1];
    int DT;
    int HD;
    int Data[N][N];
    Node * Link;
};

/* 
 * Function to print Content of the Structure Node 
 */
void toString(Node * node) {
    cout << "UID:\t" << node->UID << endl;
    cout << "DistanceTop:\t" << node->DT << endl;
    cout << "HeuristicD:\t" << node->HD << endl;
    cout << "Data:\t" << endl;
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            cout << node->Data[i][j] << " ";
        }
        cout << endl;
    }
    if (node->Link != NULL) {
        for (int i=0; i<4; i++) {
            cout << "[" << i << "]\t" << node->Link[i].UID << endl;
        }
    }   
}

/* 
 * Fill all required values of the struct
 */
void Fill(Node * node, int dt, int hd, int data[N][N], Node * link) {
    node->DT = dt;
    node->HD = hd;
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            node->Data[i][j] = data[i][j];
            node->UID[N*i + j] = data[i][j] + '0';
        }
    }
    node->UID[N*N] = '\0';
    node->Link = link;
}

/*
 * DeepcopyData: Copy Data variable in same size array.
 * node: Original Node.
 * copy: Copy data.
 */
void DeepcopyData(Node node, int copy[N][N]) {
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            copy[i][j] = node.Data[i][j];
        }
    }
}


// TODO: Need to implement Heuristic Function
void UpdateHD(Node * node) {
    int x[N*N];
    int y[N*N];
    // TODO:
}

/*
 * This function empty tile in the node.
 * Returns: Add X, Y coordinate of 0 Tile in Array 'arr'
 */
void FindZeros(int data[N][N], int * arr) {
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            if (data[i][j] == 0) {
                *(arr + 0) = i;
                *(arr + 1) = j;
                return;
            }
        }
    }
}

/*
 * Helper function to print 2D Array
 */
void temp_display(int data[N][N]) {
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            cout << data[i][j] << " ";
        }
        cout << endl;
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
void GetNeighbours(Node currentNode, Node * neighbours) {
    // Node neighbours[4];
    int arr[2];
    FindZeros(currentNode.Data, arr);
    cout << "X: " << arr[0] << "\tY: " << arr[1] << endl;

    // Case 1: Corner 1, 2, 3, 4
    if (arr[0] == 0 && arr[1] == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[0][0] = Temp[0][1];
        Temp[0][1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[0][1] = Temp[0][0];
        Temp[0][0] = 0;
        neighbours[0] = n1;

        Temp[0][0] = Temp[1][0];
        Temp[1][0] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[1][0] = Temp[0][0];
        Temp[0][0] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    else if (arr[0] == 0 && arr[1] == N-1) {
        // Need to repeat same for rest of the conditions
    }
    else if (arr[0] == N-1 && arr[1] == 0) {

    }
    else if (arr[0] == N-1 && arr[1] == N-1) {

    }
    // Case 2: Edge 1, 2, 3, 4
    else if (arr[0] == 0 ) {

    }
    else if (arr[1] == 0) {

    }
    else if (arr[0] == N-1) {

    }
    else if (arr[1] == N-1) {

    }
    // Case 3: Tile 0 Anywhere, except above possible location.
    else {

    }

    return;
}

// TODO: Need to implement DFS Algorithm
void DFS() {

}

// TODO: BFS Algorithm
void BFS() {

}

// TODO: A* Algorithm
void AStar() {

}

// TODO: IDA* Algorithm
void IDAStar() {

}

int main(int argc, char const *argv[]) {
    int Start[N][N] = {
        {0, 1, 2},
        {3, 4, 5},
        {6, 7, 8}
        };
    Node root;
    Fill(&root, 0, 0, Start, NULL);
    // toString(&root);

    Node Temp[4];
    GetNeighbours(root, Temp);

    return 0;
}

 
