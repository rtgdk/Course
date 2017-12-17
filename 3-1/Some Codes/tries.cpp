//https://www.hackerrank.com/challenges/ctci-contacts
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
typedef struct Tries tr;
struct Tries{
    int nos;
    char ch;
    tr** child;
    bool word;
};
tr* make(char ch){
    tr* newtr = (tr*)malloc(sizeof(tr));
    newtr->nos=0;
    newtr->ch=ch;
    newtr->word=false;
    newtr->child = (tr**)malloc(26*sizeof(tr*));
    for (int i=0;i<26;i++){
        newtr->child[i]= NULL;
    }
    return newtr;
}

int main(){
    int n;
    cin >> n;
    tr* newtr = make('*');
    //newtr= fill(newtr);
    for(int a0 = 0; a0 < n; a0++){
        string op;
        string contact;
        cin >> op >> contact;
        if (op=="add"){
            tr* it = newtr;
            for(int i=0;i<contact.size();i++){
                it->nos++;
                int diff = contact[i]-'a';
                if(it->child[diff]==NULL){
                    it->child[diff] = make(contact[i]);
                    //it = fill(it);
                }
                it = it->child[diff];  
            }
            it->nos++;
            it->word=true;
        }
        else{
            tr* it = newtr;
            int f=0;
            for(int i=0;i<contact.size();i++){
                int diff = contact[i]-'a';
                if(it->child[diff]==NULL){
                    f=1;
                    break;
                }
                else{
                    it=it->child[diff];
                }
            }
            if(f==0){
                cout << it->nos <<endl;
            }
            else cout << 0 <<endl;
        }
    }
    return 0;
}

