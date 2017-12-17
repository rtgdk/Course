#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
void print(int* t,unsigned int pos)
{
	int i=0;
	unsigned int flag;
	for(;i<pos;i++)
	{
		flag=1;	
		flag=flag<<i;
		if((t[i/32]&flag)==flag)
		{
			printf("%d ",i);		
		}
	}
}

void Union(int* t1,int* t2,unsigned int pos)
{
		
	int k=(int)ceil((double)(pos/32));
	int* c=(int *)malloc(k*sizeof(int));
	int i=0;
	unsigned int flag;
	for(;i<k;i++)
	{
		c[i]=t1[i]|t2[i];	
	}
	print(c,pos);
}

void Intersection(int* t1,int* t2,unsigned int pos)
{
		
	int k=(int)ceil((double)(pos/32));
	int* c=(int *)malloc(k*sizeof(int));
	int i=0;
	int f=0;
	unsigned int flag;
	for(;i<k;i++)
	{
		c[i]=t1[i]&t2[i];	
	}
	for(i=0;i<k;i++)
	{
		if(c[i]!=0)
		{
			f=1;
			break;			
		}	
	}
	if(f==0)
	{
		printf("NULL");	
	}
	else
	{
		print(c,pos);
	}
}

void Difference(int* t1,int* t2,unsigned int pos)
{
		
	int k=(int)ceil((double)(pos/32));
	int* c=(int *)malloc(k*sizeof(int));
	int i=0;
	int f=0;
	unsigned int flag;
	for(;i<k;i++)
	{
		c[i]=t1[i]-(t1[i]&t2[i]);	
	}
	for(i=0;i<k;i++)
	{
		if(c[i]!=0)
		{
			f=1;
			break;			
		}	
	}
	if(f==0)
	{
		printf("NULL");	
	}
	else
	{
		print(c,pos);
	}
}

void setbit(int *t,int k)
{
	int i = k/32;            // i = array index (use: A[i])
        int pos = k%32;          // pos = bit position in A[i]
	unsigned int flag = 1;   // flag = 0000.....00001
	flag = flag << pos;      // flag = 0000...010...000   (shifted k positions)
	t[i] = t[i] | flag;      // Set the bit at the k-th position in A[i]
}

int main()
{
	int c,i,p1,p2,k;
	int t;
	int* a;
	int* b;
	char ch;
	unsigned int N;
	scanf("%d",&c);
	while(1)
	{
		if(c==0)
		{	
			scanf("%u",&N);
			scanf("%d",&p1);
			scanf("%d",&p2);
			k=(int)ceil((double)(N/32));
			printf("%d",k);
			a=(int *)malloc(k*sizeof(int));
			b=(int *)malloc(k*sizeof(int));
			for(i=0;i<p1;i++)
			{
				scanf("%d",&t);
				setbit(a,t);
			}
			for(i=0;i<p2;i++)
			{
				scanf("%d",&t);
				setbit(b,t);	
			}
			for(i=0;i<k;i++)
			{
				printf("%d---%d",a[i],b[i]);
			}
				
		}
		if(c==1)
		{
			Union(a,b,N);
			printf("\n");	
		}
		if(c==2)
		{
			Intersection(a,b,N);
			printf("\n");
		}
		if(c==3)
		{
			Difference(a,b,N);
			printf("\n");
		}
		if(c==-1)
		{
			return 0;		
		}
		scanf("%d",&c);
	}	
}
