#include <stdio.h>

int main()
{
char *a,*c,b[4]={"red"};
a=b;
c=&b;
printf("%d %d %d %d",b,a,&a,&b,&c);
//ain(b[0]);
}

