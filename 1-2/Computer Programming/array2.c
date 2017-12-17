#include <stdio.h>
int main()
{
int a[10],i,j=0,k=0,b[10];
for (i=0;i<10;i++)
scanf("%d",&a[i]);
for (i=0;i<10;i++)
{
if (a[i]%2==0)
{
b[j]=a[i];
j+=1;
}
else if (a[i]%2!=0)
{
b[9-k]=a[i];
k+=1;
}
}
for (i=0;i<10;i++)
printf("%d",b[i]);
}

