#include <bits/stdc++.h>
using namespace std;

int main(int argc, char const *argv[])
{
	string n;
	cin >> n;
	int sm,count=9,k=9,i=1;
	int sz = n.size();
	char a = n[0];
	while(i<sz){
		if(n[i]==a) {
			a=n[i];
			i++;
		}
		else {
			a=n[i];
			count*=k;
			k--;
			i++;
		}


	}
	cout << count <<endl;
	return 0;
}