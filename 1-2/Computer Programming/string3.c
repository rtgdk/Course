#include <stdio.h>
int main()
{
char s[15];
scanf("%s",s);
long int city, ph;
sscanf(s,"+91-%d-%d",&city,&ph);
printf("%d %d",city,ph);
}
