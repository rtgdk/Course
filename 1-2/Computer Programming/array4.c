#include <stdio.h>
int main()
{
int a[]={1,2,3,4,5,6,7,8,9,99},i,j,n,temp,temp2;
scanf("%d",&n);
for (i=0;i<10;i++)
{
if (a[i]>n && a[i-1]<=n)
{
temp=a[i];
a[i]=n;
break;
}
}
for (i;i<11;i++)
{
temp2=a[i+1];
a[i+1]=temp;
temp=temp2;
}
for (i=0;i<11;i++)
printf("%d \t",a[i]);
}


