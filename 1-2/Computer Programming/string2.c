#include <stdio.h>
#include <string.h>
int main()
{
int i,j,n;
scanf("%d",&n);
char a[n][50];
printf("enter");
for (i=1;i<=n;i++)
{
scanf("%[^\n]",a[i]);
printf("%d",i);

}
printf("%s",a[1]);
}

