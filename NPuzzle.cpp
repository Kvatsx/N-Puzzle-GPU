// Kaustav Vats (2016048)
// Anubhav Jaiswal (2016014)
// Arshdeep Singh (2016018)

#include <iostream>
#include <cstring>
#include <bits/stdc++.h> 
#include <chrono>
#include "Helper.h"

// for N=8, 15, 24
// #define FINAL_STATE {{0, 1}, {2, 3}}
// #define FINAL_STATE {{0, 1, 2}, {3, 4, 5}, {6, 7, 8}}
#define FINAL_STATE {{0, 1, 2, 3}, {4, 5, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}}
// #define FINAL_STATE {{0, 1, 2, 3, 4}, {5, 6, 7, 8, 9}, {10, 11, 12, 13, 14}, {15, 16, 17, 18, 19}, {20, 21, 22, 23, 24}}

using namespace std;
using namespace std::chrono; 

class HeuristicFunctionClass {
public:
    bool operator() (Node& left, Node& right) {
        int finalState[N][N] = FINAL_STATE;
        UpdateHD(left, finalState);
        UpdateHD(right, finalState);
        int leftSum = left.HD + left.DT;
        int rightSum = right.HD + right.DT;
        return leftSum > rightSum;
    }
};
   
/*
 * Notes:
 * 1. 0 is denoted as blank tile.
 */

void DFS(Node root, int finalState[N][N]) {
    cout << "DFS:" << endl;
    map<string, int> Visited;
    stack<Node> S;

    S.push(root);
    int steps = 0;

    while(!S.empty()) {
        Node CurrentNode;
        CurrentNode = S.top();
        S.pop();
        Visited.insert({CurrentNode.UID, 1});

        // cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of nodes visited:\t" << steps << endl;
            return;
        }

        GetNeighbours(&CurrentNode);
        for(int i=3; i>=0; i--) {
            if (CurrentNode.Link[i].DT != 0) {
                if (Visited.find(CurrentNode.Link[i].UID) == Visited.end()) {
                    S.push(CurrentNode.Link[i]);
                }
            }
        }

    }
}

void BFS(Node root, int finalState[N][N]) {
    cout << "BFS:" << endl;
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
        // cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of nodes visited:\t" << steps << endl;
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
void AStar(Node root, int finalState[N][N]) {
    cout << "A*:" << endl;
    map<string, int> Visited;
    Visited.insert({root.UID, 1});
    // cout << "Found: " << Visited.find({root.UID})->first << endl;
    // return;
    priority_queue<Node, vector<Node>, HeuristicFunctionClass> Q;
    
    Q.push(root);
    int steps = 0;

    while(Q.size() > 0) {
        Node CurrentNode;
        CurrentNode = Q.top();
        Q.pop();
        // cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of nodes visited:\t" << steps << endl;
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

// TODO: IDA* Algorithm
void IDAStar(Node root, int finalState[N][N]) {

    cout << "IDA*:" << endl;
    map<string, int> Visited;
    stack<Node> S;

    S.push(root);
    UpdateHD(root, finalState);
    int threshold = root.HD;
    int steps = 0;

    while(!S.empty()) {
        Node CurrentNode;
        CurrentNode = S.top();
        S.pop();
        Visited.insert({CurrentNode.UID, 1});

        // cout << "[" << steps << "]\t" << CurrentNode.UID << endl;
        steps++;
        if (checkSolution(&CurrentNode, finalState) == 0) {
            cout << "No of nodes visited:\t" << steps << endl;
            return;
        }

        GetNeighbours(&CurrentNode);
        for(int i=3; i>=0; i--) {
            // cout << "sdf " << CurrentNode.Link[i].UID << endl;
            if (CurrentNode.Link[i].DT != 0 && CurrentNode.Link[i].DT < threshold+1) {
                if (Visited.find(CurrentNode.Link[i].UID) == Visited.end()) {
                    S.push(CurrentNode.Link[i]);
                }
            }
        }

    }


}

int main(int argc, char const *argv[]) {
    // int Start[N][N] = {
    //     {1, 0, 2},
    //     {3, 4, 5},
    //     {6, 7, 8}
    // };
    // int Start[N][N] = {
    //     {0, 3},
    //     {2, 1}
    // };
    int Start[N][N] = {
        {3, 1, 2, 0}, {4, 5, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}
    };
    // int Start[N][N] = {
    //     {4, 1, 2, 3, 0}, {5, 6, 7, 8, 9}, {10, 11, 12, 13, 14}, {15, 16, 17, 18, 19}, {20, 21, 22, 23, 24}
    // };

    int FinalState[N][N] = FINAL_STATE;
    Node root, final;
    Fill(&root, 0, 0, Start, NULL);
    // temp_display(root.Data);
    Fill(&final, 0, 0, FinalState, NULL);

    void (*solveFunctionSet[])(Node, int[N][N]) = {
        BFS,
        DFS,
        AStar,
        IDAStar
    };

    int solverCount = sizeof(solveFunctionSet)/sizeof(*solveFunctionSet);
    for(int i=0; i<solverCount; i++) {
        auto start = high_resolution_clock::now(); 

        // call the function
        (*solveFunctionSet[i])(root, FinalState);

        auto stop = high_resolution_clock::now(); 
        auto duration = duration_cast<microseconds>(stop - start);
        cout << "Time taken: " << duration.count() << " us" << endl;

        cout << endl;
    }

    return 0;
}

 
