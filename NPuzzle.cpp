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

void DFS(Node root, int finalState[N][N]) {
    cout << "----------DFS--------" << endl;
    map<string, int> Visited;
    stack<Node> S;

    S.push(root);
    int steps = 0;

    while(!S.empty()) {
        Node CurrentNode;
        CurrentNode = S.top();
        S.pop();
        Visited.insert({CurrentNode.UID, 1});

        cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of steps:\t" << steps << endl;
            return;
        }

        GetNeighbours(&CurrentNode);
        for(int i=0; i<4; i++) {
            if (CurrentNode.Link[i].DT != 0) {
                if (Visited.find(CurrentNode.Link[i].UID) == Visited.end()) {
                    S.push(CurrentNode.Link[i]);
                }
            }
        }

    }
}

void BFS(Node root, int finalState[N][N]) {
    cout << "----------BFS--------" << endl;
    map<string, int> Visited;
    Visited.insert({root.UID, 1});
    // cout << "Found: " << Visited.find({root.UID})->first << endl;
    // return;
    queue<Node> Q;
    
    Q.push(root);
    int steps = 0;

    while(Q.size() > 0) {
        Node CurrentNode;
        CurrentNode = Q.front();
        Q.pop();
        cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of steps:\t" << steps << endl;
            return;
        }

        GetNeighbours(&CurrentNode);
        for(int i=0; i<4; i++) {
            if (CurrentNode.Link[i].DT != 0) {
                if (Visited.find(CurrentNode.Link[i].UID) == Visited.end()) {
                    Q.push(CurrentNode.Link[i]);
                    Visited.insert({CurrentNode.Link[i].UID, 1});
                }
            }
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
        {1, 4, 2},
        {3, 0, 5},
        {6, 7, 8}
    };

    int FinalState[N][N] = {
        {0, 1, 2},
        {3, 4, 5},
        {6, 7, 8}
    };
    Node root;
    Fill(&root, 0, 0, Start, NULL);

    BFS(root, FinalState);
    DFS(root, FinalState);

    return 0;
}

 
