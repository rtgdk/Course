#include <bits/stdc++.h>
using namespace std;




int findmax(std::vector<int> v,int n,int m){
	int dp[m+1][n+1] ;
	memset(dp,2000,sizeof(dp));
	sort(v.begin(),v.end());
	for(int i=0;i<=n;i++){
		dp[0][i] = 0;
	}
	for(int i=0;i<=m;i++){
		dp[i][0] = 0;
	}
	for(int i=1;i<=m;i++){
		if(v[i]<=n)
			dp[i][v[i-1]] = 1;
	}
	for(int i=1;i<=m;i++){
		for(int j=1;j<=n;j++){
			if (i-1==0){
				if(j==v[i-1]){
					continue;
				}
				else {
					if (j-v[i-1]>0){
						//cout << "here" << i << " " << j <<endl;
						dp[i][j] = min(2000,1+dp[i][j-v[i-1]]);
					}
					else{
						dp[i][j] = 2000;
					}
				}
			}
			else{
				if(j==v[i-1]){
					continue;
				}
				else{
					if (j-v[i-1]>0){
						dp[i][j] = min(dp[i-1][j],1+dp[i][j-v[i-1]]);
					}
					else{
						dp[i][j] = dp[i-1][j];
					}
				}
			}
		}
	}
	// for(int i=0;i<=m;i++){
	// 	for(int j=0;j<=n;j++){
	// 		cout << dp[i][j] << " " ;
	// 	}
	// 	cout << endl;
	// }
	return dp[m][n];
}


int main(int argc, char const *argv[])
{
	int n,m;
	cin >> n >> m;
	std::vector<int> v(m);
	for(int i=0;i<m;i++){
		cin >> v[i];
	}
	int res  = findmax(v,n,m);
	cout << res <<endl;
	return 0;
}