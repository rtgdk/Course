//Asked in Tower Research Capital , BITS PILANI,31 Aug 2017
#include <bits/stdc++.h>

using namespace std;

int main(int argc, char const *argv[])
{
	
	int n;

	cin >>n;
	vector<int> v(n);
	for(int i=0;i<n;i++){
		cin >> v[i];
	}
	int k;
	cin >> k;
    //printf("%d\n",k);
	int low=0,high=0,mul=1,count=0;
    mul*=v[high];
	while(low!=n && high!=n){
		if(mul<k){
			high++;
			count += (high-low);
            mul*=v[high];
		}
		else{
			mul/=v[low];
			low++;
		}
	}
	printf("%d",count);
	return 0;
}
