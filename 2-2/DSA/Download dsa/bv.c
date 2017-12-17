#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void print(int t,int pos)
{
	int flag;
	flag=1;	
	flag=flag<<pos;
	if((t&flag)==flag)
	{
		printf("1");		
	}
	else
	{
		printf("0");	
	}
}

int setbit(int t,int k)
{
	int flag = 1;
	flag = flag << k;
	t = t | flag;
	return t;
}


int main()
{
	int c,i,p1,k;
	int t;
	int a;
	char ch;
	unsigned int N;
	scanf("%d",&c);
	while(1)
	{
		if(c==0)
		{	
			a=0;
		}
		if(c==1)
		{
			scanf("%d",&t);
			a=setbit(a,t);	
		}
		if(c==2)
		{
			scanf("%d",&t);
			print(a,t);
			printf("\n");
		}
		if(c==-1)
		{
			return 0;		
		}
		scanf("%d",&c);
	}	
}
