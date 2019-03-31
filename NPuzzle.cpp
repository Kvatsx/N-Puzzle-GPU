// Kaustav Vats (2016048)
// Anubhav Jaiswal (2016014)
// Arshdeep Singh (2016018)

#include <iostream>
#include <cstring>
#include <bits/stdc++.h> 
#include <queue> 
#include "Helper.h"

using namespace std;
   
/*
 * Notes:
 * 1. 0 is denoted as blank tile.
 */

// TODO: Need to implement DFS Algorithm
void DFS() {

}

// TODO: BFS Algorithm
void BFS(Node root) {
    map<string, int> Visited;
    Visited.insert({root.UID, 1});
    queue<Node> Q;
    
    Q.push(root);

    while(Q.size() > 0) {
        Node CurrentNode;
        CurrentNode = Q.front();
        Q.pop();
        cout << "LOL\n";
        Node Temp[4];
        GetNeighbours(CurrentNode, Temp);
        toString(&CurrentNode);
        for(int i=0; i<4; i++) {
            // if (CurrentNode.Link[i] == 0){
            //     break;
            // }
        }

    }

}

// TODO: A* Algorithm
void AStar() {

}

// TODO: IDA* Algorithm
void IDAStar() {

}

int main(int argc, char const *argv[]) {
    int Start[N][N] = {
        {2, 3, 6},
        {5, 1, 0},
        {8, 7, 4}
        };
    Node root;
    Fill(&root, 0, 0, Start, NULL);
    toString(&root);
    // BFS(root);
    // Node Temp[4];
    // GetNeighbours(root, Temp);

    return 0;
}

 
