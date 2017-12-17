//http://www.geeksforgeeks.org/dynamic-programming-set-11-egg-dropping-puzzle/
#include <bits/stdc++.h>
using namespace std;


int result(int n,int k){
	int dp[n+1][k+1];
	for(int i=0;i<=k;i++){
		dp[0][i] = 0;
		dp[1][i] = i;
	}
	for(int i=0;i<=n;i++){
		dp[i][0] = 0;
		dp[i][1] = 1;
	}
	for(int i=2;i<=n;i++){
		for(int j=2;j<=k;j++){
			dp[i][j] = INT_MAX;
			for(int l=1;l<=j;l++){
				int res = 1 + max(dp[i-1][l-1],dp[i][j-l]);
				if (res < dp[i][j]){
					dp[i][j] = res;
				}
			}
		}

	}
	return dp[n][k];

}


int main(int argc, char const *argv[])
{
	int n;
	int k;
	cin >>n >>k;
	cout << result(n,k) <<endl;
	return 0;
}