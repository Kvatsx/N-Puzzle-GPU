// Kaustav Vats (2016048)
// Anubhav Jaiswal (2016014)
// Arshdeep Singh (2016018)

#include <iostream>
#include <cstring>
#include "Helper.h"

using namespace std;

/*
 * Notes:
 * 1. 0 is denoted as blank tile.
 */

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
void FindZeros(int data[N][N], int * x, int * y) {
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
    int x, y;
    FindZeros(currentNode.Data, &x, &y);
    cout << "Zero Coordinates\nX: " << x << "\tY: " << y << endl;

    // Case 1: Corner 1, 2, 3, 4
    if (x == 0 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    else if (x == 0 && y == N-1) {
        // Need to repeat same for rest of the conditions
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    else if (x == N-1 && y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    else if (x == N-1 && y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;
        neighbours[2] = {0};
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    // Case 2: Edge 1, 2, 3, 4
    else if (x == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n3;
        Fill(&n3, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};    
        currentNode.Link = neighbours;
        toString(&currentNode);

    }
    else if (y == 0) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n3;
        Fill(&n3, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};    
        currentNode.Link = neighbours;
        toString(&currentNode);

    }
    else if (x == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    else if (y == N-1) {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;
        neighbours[3] = {0};
        currentNode.Link = neighbours;
        toString(&currentNode);
    }
    // Case 3: Tile 0 Anywhere, except above possible location.
    else {
        int Temp[N][N];
        DeepcopyData(currentNode, Temp);
        Temp[x][y] = Temp[x+1][y];
        Temp[x+1][y] = 0;
        Node n1;
        Fill(&n1, currentNode.DT+1, -1, Temp, NULL);
        Temp[x+1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[0] = n1;

        Temp[x][y] = Temp[x][y-1];
        Temp[x][y-1] = 0;
        Node n2;
        Fill(&n2, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y-1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[1] = n2;

        Temp[x][y] = Temp[x-1][y];
        Temp[x-1][y] = 0;
        Node n3;
        Fill(&n3, currentNode.DT+1, -1, Temp, NULL);
        Temp[x-1][y] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[2] = n3;

        Temp[x][y] = Temp[x][y+1];
        Temp[x][y+1] = 0;
        Node n4;
        Fill(&n4, currentNode.DT+1, -1, Temp, NULL);
        Temp[x][y+1] = Temp[x][y];
        Temp[x][y] = 0;
        neighbours[3] = n4;
        currentNode.Link = neighbours;
        toString(&currentNode);
    }

    return;
}
