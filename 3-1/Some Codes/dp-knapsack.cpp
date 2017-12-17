#include <bits/stdc++.h>
using namespace std;

#define forn(i,n) for(int i=0;i<=n;i++)


void print(int n,int k,int **arr){
	forn(i,n){
		forn(j,k){
			printf("%d ",arr[i][j]);
		}
		printf("\n");
	}
}
int main(int argc, char const *argv[])
{
	int n,k;
	int **dp;
	cin >> n >> k;
	std::vector<int> w(n);
	std::vector<int> v(n);
	dp = (int**)malloc(sizeof(int*)*(n+1));

	//memset(dp,0,sizeof(int)*(n+1)*(k+1));
	//int dp[n+1][k+1];
	for(int i=0;i<n;i++){
		dp[i] = (int*)malloc(sizeof(int)*(k+1));
		cin >> w[i];
	}
	for(int i=0;i<n;i++){
		cin >> v[i];
	}
	dp[n] = (int*)malloc(sizeof(int)*(k+1));
	forn(i,n){
		forn(j,k){
			if(i==0 || j==0){
				dp[i][j]=0;
			}
			else if(w[i-1]<=j){
				dp[i][j] = max(dp[i-1][j],dp[i-1][j-w[i-1]]+v[i-1]);
			}
			else{
				dp[i][j] = dp[i-1][j];
			}
		}
	}
	//cout << dp[n][k] <<endl;
	print(n,k,dp);


	return 0;
}