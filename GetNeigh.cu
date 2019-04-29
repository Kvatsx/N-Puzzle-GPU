#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
// #include <math.h>
#include <ctime>
#include <bits/stdc++.h> 
#include "Helper.h"
#include <cmath>

using namespace std;


// class GetNeighbours {
// public:

    
// };

int main() {
    int Start[][N] = {
        {3, 1, 2, 5}, {4, 0, 6, 7}, {8, 9, 10, 11}, {12, 13, 14, 15}
    };
    Node root;
    Fill(&root, 0, 0, Start, NULL);
    // GetNeighbours gn;
    find_my_neigh(root);
}
