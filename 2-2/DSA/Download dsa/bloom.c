#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int hash1(int k,int N)
{
	int a=((7*k)+11)%N;
	return a;
}

int hash2(int k,int N)
{
	int a=((11*k)+13)%N;
	return a;
}

int hash3(int k,int N)
{
	int a=((13*k)+17)%N;
	return a;
}

int hash4(int k,int N)
{
	int a=((17*k)+19)%N;
	return a;
}

int hash5(int k,int N)
{
	int a=((19*k)+23)%N;
	return a;
}

void hashf(int* hash, int t,int N)
{
	hash[0] = hash1(t,N);
	hash[1] = hash2(t,N);
	hash[2] = hash3(t,N);
	hash[3] = hash4(t,N);
	hash[4] = hash5(t,N);
}

int print(int t,int pos)
{
	int flag;
	flag=1;	
	flag=flag<<pos;
	if((t&flag)==flag)
	{
		return 1;		
	}
	else
	{
		return 0;	
	}
}

int setbit(int t,int k)
{
	int flag = 1;
	flag = flag << k;
	t = t | flag;
	return t;
}

int hashq(int b,int* hash,int m)
{
	int i=0;
	for(;i<m;i++)
	{
		if(print(b,hash[i])==0)
		{
			return 0;
		}	
	}
	return 1;
}

int hashp(int* a, int* hash,int t,int m)
{
	int i=0;
	for(;i<m;i++)
	{
		if(a[hash[i]]==0)
		{
			return 0;
		}	
	}
	return 1;
}

void expe(int d,int m,int N)
{
	double p=-(double)(d*m)/(double)N;
	p=exp(p);
	p=1-p;
	p=pow(p,d);
	printf("%f",p);
}

int main()
{
	int c,i,m,p,x,k=0;
	int t;
	int* a;
	int* hash=(int *)malloc(5*sizeof(int));
	int b;
	char ch;
	unsigned int N;
	scanf("%d",&c);
	while(1)
	{
		if(c==0)
		{	
			scanf("%d",&x);		
			scanf("%d",&N);
			for(i=0;i<5;i++)
			{
				hash[i]=0;
			}			
			if(x==2)
			{			
				a=(int *)malloc(N*sizeof(int));
				for(i=0;i<N;i++)
				{
					a[i]=0;
				}
			}
			else
			{
				if(x==1)
				{
					b=0;			
				}
			}
		}
		if(c==1)
		{
			scanf("%d",&t);
			hashf(hash,t,N);
			if(x==2)
			{			
				if(hashp(a,hash,t,5)==0&&t<N&&t>=0)
				{
					for(i=0;i<5;i++)
					{
						a[hash[i]]=1;
					}
					k++;
				}				
			}
			else
			{
				if(x==1)
				{
					if(hashq(b,hash,5)==0&&t<N&&t>=0)
					{
						for(i=0;i<5;i++)
						{
							b=setbit(b,hash[i]);
						}
						k++;
					}		
				}
			}
		}
		if(c==2)
		{
			scanf("%d",&t);
			hashf(hash,t,N);
			if(x==2)
			{							
				if(hashp(a,hash,t,5)&&t<N&&t>=0)
				{
					printf("1");
				}
				else
				{
					printf("0");				
				}				
			}
			else
			{
				if(x==1)
				{
					if(hashq(b,hash,5)&&t<=31&&t>=0)
					{
						printf("1");					
					}
					else
					{
						printf("0");
					}			
				}
			}	
			printf("\n");
		}
		if(c==3)
		{
			for(i=0;i<5;i++)
			{
				hash[i]=0;
			}
			if(x==2)
			{			
				for(i=0;i<N;i++)
				{
					a[i]=0;
				}
			}
			else
			{
				if(x==1)
				{
					b=0;			
				}
			}
			k=0;		
		}
		if(c==4)
		{
			scanf("%d",&p);				
			scanf("%d",&m);
			while(p!=0)
			{			
				scanf("%d",&c);				
				if(c==1)
				{
					scanf("%d",&t);
					hashf(hash,t,N);
					if(x==2)
					{			
						if(hashp(a,hash,t,m)==0&&t<N&&t>=0)
						{
							for(i=0;i<m;i++)
							{
								a[hash[i]]=1;
							}
							k++;
						}				
					}
					else
					{
						if(x==1)
						{
							if(hashq(b,hash,m)==0&&t<N&&t>=0)
							{
								for(i=0;i<m;i++)
								{
									b=setbit(b,hash[i]);
								}
								k++;
							}		
						}
					}
					expe(m,k,N);
					printf("\n");	
				}
				if(c==2)
				{
					scanf("%d",&t);
					hashf(hash,t,N);
					if(x==2)
					{							
						if(hashp(a,hash,t,m)&&t<N&&t>=0)
						{
							printf("1");
						}
						else
						{
							printf("0");				
						}				
					}
					else
					{
						if(x==1)
						{
							if(hashq(b,hash,m)&&t<=31&&t>=0)
							{
								printf("1");					
							}
							else
							{
								printf("0");
							}			
						}
					}
					printf("\t");
					expe(m,k,N);	
					printf("\n");
				}
				p--;	
			}	
		}
		if(c==-1)
		{
			return 0;		
		}
		scanf("%d",&c);
	}	
}
