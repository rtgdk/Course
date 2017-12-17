#include <bits/stdc++.h>

using namespace std;

struct rec{
    int h;
    int b;
};


bool sortfn(struct rec a,struct rec b){
    if ((a.h*a.b)>(b.h*b.b)){
        return true;
    }
    else {
        return false;
    }
}
int main(){
    vector<struct rec> r(5);
    r[0].h = 1;
    r[0].b = 5;
    r[1].h = 2;
    r[1].b = 3;
    r[2].h = 3;
    r[2].b = 4;
    r[3].h = 5;
    r[3].b = 4;
    r[4].h = 0;
    r[4].b = 1;
    sort(r.begin(),r.end(),sortfn);
    for (int i=0;i<5;i++){
        cout << r[i].h <<" " << r[i].b <<endl;
    }
    return 0;
}
