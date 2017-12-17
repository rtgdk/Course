//http://practice.geeksforgeeks.org/problems/non-repeating-character/0
#include <bits/stdc++.h>
using namespace std;

int hash1[26];
int hash2[26];
int main() {
	//code
	string s;
	cin >> s;
	
	for(int i=0;i<s.size();i++){
	    hash1[s[i]-'a'] = i;
	    hash2[s[i]-'a']++;
	}
	int ele = INT_MAX;
	for(int i=0;i<26;i++){
	    if(hash2[i]==1){
	        if(ele>hash1[i])
	            ele = hash1[i];
	    }
	}
	cout << s[ele] <<endl;
	return 0;
}
