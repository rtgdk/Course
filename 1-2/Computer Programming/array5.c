#include <stdio.h>
int main()
{
int a[10]={1,2,3,4,5,5,6,7,8,8},j,k=0,i,f,b[10];
for (i=0;i<10;i++)
{
f=0;
for (j=0;j<i;j++)
{
	if (a[j]==a[i])
	{
	f=1;
	break;
	}
}
if (f==0)
{
b[k]=a[i];
k+=1;
}
}
for (i=0;i<k;i++)
printf("%d \n",b[i]);
}
