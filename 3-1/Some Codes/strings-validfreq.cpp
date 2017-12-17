//https://www.hackerrank.com/challenges/sherlock-and-valid-string
#!/bin/python3

import sys

def isValid(s):
    has = [0]*26
    for i in s:
        has[ord(i)-ord('a')]=has[ord(i)-ord('a')]+1
    e = max(has)
    max2=0
    max1=0
    one =0
    for i in has:
        if i==e:
            max2=max2+1
        elif i==(e-1):
            max1 =max1+1
        elif i==1:
            one =one +1
        elif (i!=0):
            return "NO"
    fr = max(max2,max1,one)
    #print (max2)
    #print(max1)
    #print(one)
    if (fr == max2):
        if ((max1==1 and one ==0) or (max1==0 and one ==1) or (max1==0 and one==0)):
            return "YES"
        else: 
            return "NO"
    elif(fr == max1):
        if ((max2==1 and one ==0) or (max2==0 and one ==1) or (max2==0 and one==0)):
            return "YES"
        else: 
            return "NO"
    else :
        return "NO"
            
    
    # Complete this function

s = input().strip()
result = isValid(s)
print(result)

