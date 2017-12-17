#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void print(int* t,int pos)
{
	if((t[pos])==1)
	{
		printf("1");		
	}
	else
	{
		printf("0");	
	}
}

int setbit(int* t,int k)
{
	t[k] = t[k] | 1;
}


int main()
{
	int c,i,p1,k;
	int t;
	int* a;
	char ch;
	unsigned int N;
	scanf("%d",&c);
	while(1)
	{
		if(c==0)
		{	
			scanf("%d",&N);			
			a=(int *)malloc(N*sizeof(int));
			for(i=0;i<N;i++)
			{
				a[i]=0;
			}
		}
		if(c==1)
		{
			scanf("%d",&t);
			setbit(a,t);	
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
