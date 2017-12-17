#include <stdio.h>
int main()
{
int a[5],i,j,temp;
for(i=0;i<5;i++)
scanf("%d",&a[i]);
for(i=0;i<5;i++)
{
for(j=0;j<5;j++)
{
if (a[j+1]<a[j])
{
temp=a[j];
a[j]=a[j+1];
a[j+1]=temp;
}
}
}
for(i=0;i<5;i++)
printf("%d \n",a[i]);
}

