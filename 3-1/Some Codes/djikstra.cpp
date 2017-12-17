//https://www.hackerrank.com/challenges/dijkstrashortreach
#include <bits/stdc++.h>

using namespace std;


vector<int> cou(int s, vector<int> v[],int n,int m){
    vector <int> v1(n+1,-1);
    stack<int> s1;
    s1.push(s);
    v1[s] = 0;
    while(!s1.empty()){
        int tp = s1.top();
        s1.pop();
        //cout << "top " <<tp<<endl; 
        for (int i=1;i<=n;i++){
            if (v[tp][i]!=0){
            	if (v1[i]==-1){
            		s1.push(i);

	                v1[i]= v1[tp] + v[tp][i];
	                //cout <<  i << " " <<tp << " " <<v1[i] <<endl;
	                v[tp][i] = 0;
	                v[i][tp] = 0;
            	}
            	else if (v1[tp] +v[tp][i] < v1[i]){
	                s1.push(i);
	                v1[i]= v1[tp] + v[tp][i];
	                //cout <<  i << " " << tp << " " <<v1[i] <<endl;
	                v[tp][i] = 0;
	                v[i][tp] = 0;
	            }

            }
        }
    }
    return v1;
}
int main(){
    int t;
    cin >> t;
    for(int a0 = 0; a0 < t; a0++){
        int n;
        int m;
        cin >> n >> m;
        vector<int> v[n+1];
        for (int i=0;i<=n;i++) {
            v[i].resize(n+1);
            fill(v[i].begin(),v[i].end(),0);
        }
        for(int a1 = 0; a1 < m; a1++){
            int x;
            int y;
            int r;
            cin >> x >> y >> r;
            v[x][y]=r;
            v[y][x]=r;
        }
        int s;
        cin >> s;
        vector<int> res = cou(s,v,n,m);
        for (int i=1;i<=n;i++){
        	if (i!=s)
            	cout << res[i] << " ";
        }
        cout << endl;
    }
    return 0;
}
