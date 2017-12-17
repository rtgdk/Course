#include <stdio.h>
int factorial (int a)
{
if (a==0)
return (1);
else
{
int fact=1,i;
for (i=1;i<=a;i++)
fact=fact*i;
return (fact);
}
}
int main()
{
int n,i,j,a,b,c;
scanf("%d",&n);
for (j=1;j<=n;j++)
{
for (i=n-j;i>0;i--)
printf(" ");
for (i=0;i<j;i++)
{
a=factorial(i)*factorial(j-i-1);
b=factorial(j-1);
c=b/a;
printf("%d ",c);
}
printf("\n");
}
}
