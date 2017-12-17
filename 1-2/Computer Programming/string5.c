#include<stdio.h>
#include<string.h>

int main()
{
   char str[80],temp[80] ;
gets(str);
int b,j,sum=0;
   const char s[2] = " ";
   char *token;
   
   /* get the first token */
   token = strtok(str, s);
   /* walk through other tokens */
   while( token != NULL ) 
   {
      b=strlen(token);
	sum=sum+b+1;
	for (j=0;j<b;j++)
	temp[sum-j-1]=token[j];
	temp[sum-j-1]=' ';
      printf( " %s\n", token );
    
      token = strtok(NULL, s);
   }
   printf("%s\t ",temp);
   return(0);
}
