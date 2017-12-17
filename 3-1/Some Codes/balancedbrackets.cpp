//https://www.hackerrank.com/challenges/ctci-balanced-brackets
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
bool type(char a){
    if(a=='[' || a=='(' || a=='{') return true;
    else return false;
}
bool match(char a,char b){
    if(a=='[' && b==']') return true;
    else if(a=='(' && b==')') return true;
    else if(a=='{' && b=='}') return true;
    else return false;
}
bool is_balanced(string expression) {
    vector<char> res;
    for(int i=0;i<expression.size();i++){
        if(type(expression[i])) res.push_back(expression[i]);
        else {
            if (!res.empty() && match(res.back(),expression[i])){
                res.pop_back();
            }
            else{
                return false;
            }
        }
    }
    if(res.empty()) return true;
    else return false;
}

int main(){
    int t;
    cin >> t;
    for(int a0 = 0; a0 < t; a0++){
        string expression;
        cin >> expression;
        bool answer = is_balanced(expression);
        if(answer)
            cout << "YES\n";
        else cout << "NO\n";
    }
    return 0;
}

