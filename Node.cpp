#include <iostream>
using namespace std;

class Node {
    public:
    int N;
    int DistanceTop;
    int HeuristicDistance;
    int Data[N][N];
    Node **Link;

    Node(int n, int distance_top, int heuristic_distance, int **data,Node link) {
        N = n;
        DistanceTop = distance_top;
        HeuristicDistance = heuristic_distance;
        int i, j;
        for(i=0; i<n; i++) {
            for(j=0; j<n; j++) {
                Data[i][j] = data[i][j];
            }
        }
        Link = link;
    }

}
 