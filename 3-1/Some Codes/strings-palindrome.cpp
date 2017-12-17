//https://www.hackerrank.com/challenges/richie-rich/problem
#!/bin/python3

import sys

def findmax(s,a,b):
    return a if s[a] > s[b] else b

def richieRich(s, n, k):
    # Complete this function
    l =[None]*n
    count = 0
    new = ['0']*n
    st=""
    for i in range(0,int(n/2)+int(n%2)):
        if(s[i]!=s[n-i-1]):
            mx = findmax(s,i,n-i-1)
            l[mx] = True
            new[i] = s[mx]
            new[n-i-1] = s[mx]
            count += 1
        else :
            new[i] = s[i]
            new[n-i-1] = s[n-i-1]
    #print("count == " +str(count))
    if count > k :
        return (-1)
    if count == k :
        return st.join(new)
    if count < k:
        for i in range(0,int(n/2)+int(n%2)):
            if count < k:
                if(s[i]=='9' and s[n-i-1]=='9'):
                    new[i]='9'
                    new[n-i-1]='9'
                elif (s[i]=='9' or s[n-i-1]=='9'):
                    new[i]='9'
                    new[n-i-1]='9'
                    #count+=1
                else :
                    
                    if ((l[i] == True or l[n-i-1] ==True)):
                        new[i]='9'
                        new[n-i-1]='9'
                        count+=1
                    elif (count<k-1) :
                        new[i]='9'
                        new[n-i-1]='9'
                        count+=2
                    elif (count == (k-1) and n%2==1):
                        new[int(n/2)] ='9'
                        count =count +1
                        break
            else :
                break
        return st.join(new)
                
                    
                    
        

n,k = input().strip().split()
n,k = int(n),int(k)
s = input().strip()
result = richieRich(s, n, k)
print(result)

