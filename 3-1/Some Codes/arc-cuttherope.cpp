//http://www.geeksforgeeks.org/dynamic-programming-set-11-egg-dropping-puzzle/
#include <bits/stdc++.h>
using namespace std;

vector<int> cuttherope(std::vector<int> v,int k){
	std::vector<int> v1;
	int count=0,l=0,check=0;
	for(int i=1;i<v.size();i++){
		if (v[i-1]<v[i]){
			v1.push_back(v[i-1]);
			count++;
			if (count==k) break;
			if(check==1){
				for(int j=1;j<=l;j++){
					v1.push_back(v[i-1-j]);
					count++;
					
				}
			}

		}
		else if (v[i-1]==v[i]){
			check=1;
			l++;
		}
		else {
			check=0;
			l=0;
		}
		if(count==k) break;
	}
	//cout << "count" << count <<endl;
	if (count!=k){
		v1.push_back(v.back());
		count++;
		v.pop_back();
	}
	return v1;
}

int main(int argc, char const *argv[])
{
	int n,c;
	cin >> n;
	std::vector<int> v;
	while(n--){
		cin >> c;
		v.push_back(c);
	}
	int k;
	cin >> k;
	std::vector<int> v2 = cuttherope(v,k);
	for(int i=0;i<v2.size();i++){
		cout << v2[i] <<endl;
	}
	return 0;
}