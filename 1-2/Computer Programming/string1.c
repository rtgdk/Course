#include <stdio.h>
#include <string.h>
int main()
{
int i=0,j=0;
char a[100],temp[100];
gets(a);
while (a[i]!='\0')
{
if (a[i]==a[i+1]);
else 
{
temp[j++]=a[i];
}
i++;
}
printf("%s",temp);
return 0;
}

