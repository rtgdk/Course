//http://www.geeksforgeeks.org/largest-sum-zig-zag-sequence-in-a-matrix/
// New way to find result without storing dp table
#include <bits/stdc++.h>
using namespace std;

int main(int argc, char const *argv[])
{
	int n,m;
	cin >> n >> m;
	int arr[n][m];
	for(int i=0;i<n;i++){
		for(int j=0;j<m;j++){
			cin >> arr[i][j];
		}
	}
	int max=0,max2=0;
	int in=0,in2=0;
	//int tab[n][m];
	for(int j=0,i=n-1;j<m;j++){
		if (arr[i][j]>max){
			max2 = max;
			max = arr[i][j];
			in2=in;
			in = j;
		}
        else if(arr[i][j]>max2){
            max2 = arr[i][j];
            in2=j;
        }
	}
	int newmax,newmax2;
	int newin,newin2;
	int sum;
	for(int j=n-2;j>=0;j--){
		newmax = max;
		for(int i=0;i<m;i++){
			if (i==in) {
				sum = arr[j][i] + max2;
			}
			else {
				sum =  arr[j][i] +max; 
			}
			if(sum > newmax){
				newmax2=newmax;
				newmax = sum;
				newin2 = newin;
				newin = i;
			}
            else if(sum > newmax2){
                newmax2 = sum;
                newin2 = i;
            }
		}
		in = newin;
		in2 = newin2;
		max = newmax;
		max2 = newmax2;
        //cout << in << " " <<in2 << " " <<max << " "<<max2 <<endl;
	}
	cout << max << endl;
	return 0;
}