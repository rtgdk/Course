#include <stdio.h>
int main()
{
int a[10],max,min,i,j,k,max1,max2;
for (i=0;i<10;i++)
scanf("%d",&a[i]);
max=a[0];
min=max;
for (i=1;i<10;i++)
{
	if (a[i]>max)
	{
	max=a[i];
	j=i;
	}
	else if (a[i]<min)
	min=a[i];
}
max1=a[0];
for (i=1;i<10 ;i++)
{
	if (a[i]>max1 && i!=j)
	{
	max1=a[i];
	k=i;
	}
}
max2=a[0];
for (i=1;i<10 ;i++)
{
	if (a[i]>max2 && i!=j && i!=k)
	{
	max2=a[i];
	}
}
printf("%d %d %d %d ",max,min,max1,max2);
}
