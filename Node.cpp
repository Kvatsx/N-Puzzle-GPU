// Kaustav Vats (2016048)
// Anubhav Jaiswal ()
// Arhsdeep ()

#include <iostream>
using namespace std;

// Size of the Grid
#define N 3     


/* 
 * Structure of the node
*/
struct Node {
    int DT;
    int HD;
    int Data[N][N];
    Node *Link;
};

/* 
 * Function to print Content of the Structure Node 
*/
void toString(Node * node) {
    cout << "DistanceTop: " << node->DT << endl;
    cout << "HeuristicD: " << node->HD << endl;
    cout << "Data: " << endl;
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            cout << node->Data[i][j] << " ";
        }
        cout << endl;
    }
}

void Fill(Node * node, int dt, int hd, int data[N][N], Node * link) {
    node->DT = dt;
    node->HD = hd;
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++) {
            node->Data[i][j] = data[i][j];
        }
    }
    node->Link = link;
}

// TODO: Need to implement Heuristic Function
void UpdateHD(Node * node) {
    int x[N*N];
    int y[N*N];
    // TODO:
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
    toString(&root);

    return 0;
}

 