#include <stdio.h>
int main()
{
int n,i,j,a[3][3]={{1,2,3},{4,5,6},{7,8,9}},f=0;
scanf("%d",&n);
for (i=0;i<3;i++)
{
if (a[i][0]>n)
break;
}
for (j=0;j<3;j++)
{
if (a[i-1][j]==n)
{
f=1;
break;
}
}
if (f==1)
printf("%d %d",i-1,j);
}


