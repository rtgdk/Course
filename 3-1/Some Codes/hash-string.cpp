//https://www.hackerrank.com/challenges/ctci-ransom-note
#include <map>
#include <set>
#include <list>
#include <cmath>
#include <ctime>
#include <deque>
#include <queue>
#include <stack>
#include <string>
#include <bitset>
#include <cstdio>
#include <limits>
#include <vector>
#include <climits>
#include <cstring>
#include <cstdlib>
#include <fstream>
#include <numeric>
#include <sstream>
#include <iostream>
#include <algorithm>
#include <unordered_map>

using namespace std;
int hash1[30000];
bool ransom_note(vector<string> magazine, vector<string> ransom) {
    int sum;
    for(int i=0;i<magazine.size();i++){
        sum = 0;
        for(int j=0;j<magazine[i].size();j++){
            sum += (magazine[i][j]-'a')*pow(3,j); 
        }
        //cout << sum%30000 << endl;
        hash1[sum%30000]++;
    }
    for(int i=0;i<ransom.size();i++){
        sum = 0;
        for(int j=0;j<ransom[i].size();j++){
            sum += (ransom[i][j]-'a')*pow(3,j); 
        }
        //cout << sum%30000 << endl;
        if (hash1[sum%30000]==0){
            return false;
        }
        else{
            hash1[sum%30000]--;
        }
    }
    return true;
}

int main(){
    int m;
    int n;
    cin >> m >> n;
    vector<string> magazine(m);
    for(int magazine_i = 0;magazine_i < m;magazine_i++){
       cin >> magazine[magazine_i];
        //cout << magazine[magazine_i] <<endl;
    }
    vector<string> ransom(n);
    for(int ransom_i = 0;ransom_i < n;ransom_i++){
       cin >> ransom[ransom_i];
    }
    if(ransom_note(magazine, ransom))
        cout << "Yes\n";
    else
        cout << "No\n";
    return 0;
}

