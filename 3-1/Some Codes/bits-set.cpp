//http://practice.geeksforgeeks.org/problems/copy-set-bits-in-range/0
#include<bits/stdc++.h>
using namespace std;
int main()
 {
	//code
	int t;
	cin >> t;
	while(t--){
    	int a;
    	int b;
    	long int c=0,l,r;
    	cin >> a;
    
    	cin >> l >> r;
    		cin >> b;
    	for(int i=l;i<=r;i++) c = c + pow(2,i-1);
    	int d = b & c;
    	a = a|d;
    	cout << a << endl;
	}
	return 0;
}