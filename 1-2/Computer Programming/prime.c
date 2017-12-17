#include <stdio.h>
int main()
{
int rem,f,i,j,n;
scanf("%d",&n);
for (i=2;i<=n;i++)
{
f=1;
for (j=2;j<i;j++)
{
	if (i==2)
	{
	printf("2");
	continue;
	}
	rem=i%j;
	if (rem==0)
	{
	f=0;
	break;
	}
	else
	continue;
}
if (f==1)
printf("%d \n",i);
}
}
