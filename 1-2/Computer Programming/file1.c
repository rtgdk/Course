#include <stdio.h>
int main()
{
FILE *fp,*fp2,*fp3;
char c;
fp=fopen("string9.c","a+");
fputs("rohi",fp);
c=fgetc(fp);
while (c!=EOF)
{
printf("%c",c);
c=fgetc(fp);
}
fclose(fp);
}

