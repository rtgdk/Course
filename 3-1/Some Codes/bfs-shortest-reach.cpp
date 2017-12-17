//https://www.hackerrank.com/challenges/ctci-bfs-shortest-reach
#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
#include <queue>

using namespace std;

class Graph {
    private:
        vector< vector<int>> a;
    public:
    
        Graph(int n) {
            a.resize(n+1);
            for(int i=0;i<=n;i++){
                a[i].resize(n+1,0);
            }
        }
    
        void add_edge(int u, int v) {
            //cout << "add "<< u<< " "<<v <<endl;
            a[u][v]=1;
            a[v][u]=1;
        }
    
        vector<int> shortest_reach(int start) {
            vector<int> v(a[start].size(),-1);
            std::queue<int> q;
            std::queue<int> q1;
            q.push(start);
            q1.push(6);
            int count = 6;
            while(!q.empty()){
                for(int i = 0;i<a[q.front()].size();i++){
                    if(a[q.front()][i]==1) {
                        q.push(i);
                        q1.push(q1.front()+6);
                        if(v[i]==-1)
                            v[i]=q1.front();
                        a[q.front()][i]=0;
                        a[i][q.front()]=0;
                    }
                }
                q.pop();
                q1.pop();
                //count=count+6;
            }
            return v;
        }
    
};

int main() {
    int queries;
    cin >> queries;
        
    for (int t = 0; t < queries; t++) {
      
      int n, m;
        cin >> n;
        // Create a graph of size n where each edge weight is 6: 
        Graph graph(n);
        cin >> m;
        // read and set edges
        for (int i = 0; i < m; i++) {
            int u, v;
            cin >> u >> v;
            // add each edge to the graph
            graph.add_edge(u, v);
        }
      int startId;
        cin >> startId;
        startId;
        // Find shortest reach from node s
        vector<int> distances = graph.shortest_reach(startId);

        for (int i = 1; i < distances.size(); i++) {
            if (i != startId) {
                cout << distances[i] << " ";
            }
        }
        cout << endl;
    }
    
    return 0;
}

