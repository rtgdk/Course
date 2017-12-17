//https://www.hackerrank.com/challenges/ctci-connected-cell-in-a-grid
#include <map>
#include <set>
#include <list>
#include <cmath>
#include <ctime>
#include <deque>
#include <queue>
#include <stack>
#include <string>
#include <bitset>
#include <cstdio>
#include <limits>
#include <vector>
#include <climits>
#include <cstring>
#include <cstdlib>
#include <fstream>
#include <numeric>
#include <sstream>
#include <iostream>
#include <algorithm>
#include <unordered_map>

using namespace std;
vector< vector<int> > grid;

int get(int i,int j,int n,int m){
    int c1=0,c2=0,c3=0,c4=0,c5=0,c6=0,c7=0,c8=0;
    if (i<0 || j<0 ) return 0;
    if (i>=grid.size() || j>= grid[i].size()) return 0;
    if(grid[i][j]==2) return 0;
    grid[i][j]=2;
    if (i!=0 && j!=0 && grid[i-1][j-1]==1) c1 = get(i-1,j-1,n,m);
    if (i!=0 && grid[i-1][j]==1) c2 = get(i-1,j,n,m);
    if (i!=0 && j!=m-1 && grid[i-1][j+1]==1) c3 = get(i-1,j+1,n,m);
    if (j!=m-1 && grid[i][j+1]==1) c4 = get(i,j+1,n,m);
    if (j!=0 && grid[i][j-1]==1) c5 = get(i,j-1,n,m);
    if (i!=n-1 && j!=0 && grid[i+1][j-1]==1) c6 = get(i+1,j-1,n,m);
    if (i!=n-1 && grid[i+1][j]==1) c7 = get(i+1,j,n,m);
    if (i!=n-1 && j!=m-1 && grid[i+1][j+1]==1) c8 = get(i+1,j+1,n,m);
    //cout << i << " "<< j <<endl;
    return c1+c2+c3+c4+c5+c6+c7+c8+1;
}

int get_biggest_region(int n,int m) {
    int got;
    int max=0;
    for(int grid_i = 0;grid_i < n;grid_i++){
       for(int grid_j = 0;grid_j < m;grid_j++){
           if (grid[grid_i][grid_j]==1){
               //cout << "new" <<endl;
               got = get(grid_i,grid_j,n,m);
               if (got>max) max = got;
           }
       }
    }
    return max;
}

int main(){
    int n;
    cin >> n;
    int m;
    cin >> m;
    grid.resize(n);
    for (int i = 0; i < n; ++i)
        grid[i].resize(m);
    //vector< vector<int> > grid(n,vector<int>(m));
    for(int grid_i = 0;grid_i < n;grid_i++){
       for(int grid_j = 0;grid_j < m;grid_j++){
          cin >> grid[grid_i][grid_j];
       }
    }
    cout << get_biggest_region(n,m) << endl;
    return 0;
}

