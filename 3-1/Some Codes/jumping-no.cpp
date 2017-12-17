//http://practice.geeksforgeeks.org/problems/jumping-numbers/0
#include <bits/stdc++.h>
using namespace std;

int main(int argc, char const *argv[])
{
	/* code */
	int n,n1,x,t;
	cin >> t;
	while(t--){
    	cin >> n;
    	n1=n;
    	queue<int> q;
    	for(int i=1;i<=9;i++)
    		q.push(i);
    	while(!q.empty()){
    		x = q.front();
    		q.pop();
    		if(x<=n){
                cout << x << " ";
    			if (x %10 == 0)
    				q.push(x*10+1);
    			else if (x%10==8)
    				q.push(x*10+8);
    			else{
    				int r = x%10;
    				q.push(x*10+(r-1));
    				q.push(x*10+(r+1));
    			}
    		}
    		else{
    			break;
    		}
    	}
        cout<<endl;
	}
	return 0;
}

/* To print in order of most signficant digit(increasing) 
#include <bits/stdc++.h>
using namespace std;

int main(int argc, char const *argv[])
{
	
	int n,n1,x,t;
	cin >> t;
	while(t--){
    	cin >> n;
    	n1=n;
    	deque<int> q;
    	for(int i=1;i<=9;i++)
    		q.push_back(i);
    	while(!q.empty()){
    		x = q.front();
    		q.pop_front();
    		if(x<=n){
                cout << x << " ";
    			if (x %10 == 0)
    				q.push_front(x*10+1);
    			else if (x%10==8)
    				q.push_front(x*10+8);
    			else{
    				int r = x%10;
    				q.push_front(x*10+(r+1));
                    q.push_front(x*10+(r-1));
    			}
    		}
    		
    	}
        cout<<endl;
	}
	return 0;
}
*/
