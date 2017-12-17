#include<stdio.h>
#include<stdlib.h>
int curHeapSize=0;
int maxHeapSize=0;
struct myPtr{
	void *p;
	int size;
};
struct matrix{
	int **p;
	int id;
	int m;
	int n;
};
typedef struct myPtr myPtr;
typedef struct matrix matrix;
myPtr* myAlloc(int size){
	curHeapSize+=size;
	if(curHeapSize>maxHeapSize){
		maxHeapSize=curHeapSize;
	}
	return ((myPtr *)malloc(size));
}
void myFree(myPtr *ptr){
	curHeapSize-=ptr->size;
	free(ptr);
}
void printMatrix(matrix ma){
	int i,j;
	int n,m;
m=ma.m;
n=ma.n;
int **a=ma.p;
	for(i=0;i<m;i++){
		for(j=0;j<n;j++){
			printf("%d\t",a[i][j]);		
		}
		printf("\n");
	}	
}
void printVector(int *v,int m){
	int i;
	for(i=0;i<m;i++){
		printf("%d\t",v[i]);	
	}
	printf("\n");
}
void readMatrix(matrix al){
	int id,i,m,n,j;
	m=al.m;
	n=al.n;
	int **a=al.p;	
	for(i=0;i<m;i++){
		for(j=0;j<n;j++){
			scanf("%d",&a[i][j]);
		}
	}
	printMatrix(al);
}
int  rcMul(matrix m1,int m,matrix m2,int n){
	int id,i;//,m,n,j;	
	//scanf("%d",&id);
	//scanf("%d%d",&m,&n);
	//static int *v=(int*)malloc((m1.n)*sizeof(int));
	int s=0;	
	for(i=0;i<m1.n;i++){
		s+=(m1.p)[m-1][i]*(m2.p)[i][n-1];
	}/*
	int sum=0;
	for(i=0;i<m1.n;i++){
		sum+=v[i];
	}*/
	printf("%d\n",s);
	return s;
}
int* rmMul(matrix m1,int m,matrix m2,int flag){
	int id,i;//,m,n,j;	
	//scanf("%d",&id);
	//scanf("%d%d",&m,&n);
	static int *v;
	v=(int*)malloc((m2.n)*sizeof(int));
	int s=0;	
	for(i=0;i<m2.n;i++){		
		v[i]=rcMul(m1,m,m2,i);
	}
	if(flag==0){
		return v;	
	}
	printVector(v,m2.n);
	return v;
} 
int mmMul(matrix m1,matrix m2,matrix m3){
	
}


int main(){
	//int ***ids;
	//ids=(int ***)malloc(1000*sizeof(int**));
	matrix *ids=(matrix *)malloc(1000*sizeof(matrix));	
	int i;
	scanf("sum %d",&i);
	
	while(i!=-1){
		if(i==1){
			int id,i,m,n,j,qq;	
			scanf("%d",&id);
			scanf("%d%d",&m,&n);
			int **a=(int **)malloc(m*sizeof(int*));
			for(qq=0;qq<m;qq++){
				a[qq]=(int*)malloc(n*sizeof(int));
			}			
			matrix ml;
			ml.id=id;
			ml.m=m;
			ml.n=n;
			ml.p=a;
			ids[id]=ml;			
			readMatrix(ml);
		}
		if(i==2){
			matrix m1,m2;
			int i1,i2,m,n;
			scanf("%d%d%d%d",&i1,&m,&i2,&n);
			rcMul(ids[i1],m,ids[i2],n);
		}
		if(i==3){
			int m,n,k;
			scanf("%d%d%d",&m,&n,&k);
			rmMul(ids[m],n,ids[k],0);

		}
		if(i==4){
			int m,n,k,qq;
			scanf("%d%d%d",&m,&n,&k);
			matrix m3;
			int **a=(int **)malloc((ids[m].m)*sizeof(int*));
			for(qq=0;qq<m;qq++){
				a[qq]=(int*)malloc((ids[k].n)*sizeof(int));
			}
			m3.p=a;
			m3.m=ids[m].m;
			m3.n=ids[k].n;
			mmMul(ids[m],ids[k],m3);

		}
		scanf("sum %d",&i);
		
	} 
	return 0;
}
