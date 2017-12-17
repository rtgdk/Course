#include<stdio.h>
#include<stdlib.h>
int curHeapSize=0;
int maxHeapSize=0;
typedef struct myPtr myPtr;
typedef struct matrix matrix;
typedef struct row row;
typedef struct col col;
struct col{
	int ele;
	int c;
	col *next;
};
struct row{
	col *first;
	int r;

};

struct myPtr{
	void *p;
	int size;
};
struct matrix{
	row *p;
	int id;
	int m;
	int n;
};


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

void readMatrix(matrix al){
	int kk,id,i,m,n,j;
	//scanf("%d",&i);
	int max=0,t=1;//for max col

	for(kk=0;kk<(al.m);kk++){
				
		int j,k;
		scanf("%d",&j);
		row ro;
		ro.r=j;
		col *cc=(col*)malloc(sizeof(col));
		
		scanf("%d%d",&j,&k);
		t=1;		
		ro.first=cc;
		cc->c=j	;
		cc->ele=k;
		cc->next=NULL;
		scanf("%d",&j);	
		while(j!=-1){
			t++;			
			scanf("%d",&k);
			col *oo=(col*)malloc(sizeof(col));
			scanf("%d",&k);
			cc->next=oo;		
			oo->c=j;
			oo->ele=k;
			oo->next=NULL;
			scanf("%d",&j);	
		}
		if(max<t)
			max=t;
		}
		scanf("%d",&i);
		al.n=max;

}/*	
int * rcMul(matrix m1,int m,matrix m2,int n){
	int id,i;//,m,n,j;	
	//scanf("%d",&id);
	//scanf("%d%d",&m,&n);
	int *v=(int*)malloc((m1.n)*sizeof(int));
	for(i=0;i<m1.m;i++){
		v[i]=(m1.p)[m-1][i]*(m2.p)[i][n-1];
	}
	int sum=0;
	for(i=0;i<m1.m;i++){
		sum+=v[i];
	}
	printf("%d\n",&sum);
	return v;
}
void printMatrix(matrix ml){
	int i,j;
	int m=ml.m,n=ml.n;
	for(i=0;i<n;i++){
	
	}
	
}*/
int main(){
	//int ***ids;
	//ids=(int ***)malloc(1000*sizeof(int**));
	matrix *ids=(matrix *)malloc(1000*sizeof(matrix));	
	int i;
	scanf("sum %d",&i);
	while(i!=-1){
		if(i==0){
			int id,i,m,n,j,qq;	
			scanf("%d%d",&id,&m);
			matrix ml;
			ml.p=(row *)malloc(m*sizeof(row));
			ml.id=id;
			ml.m=m;
			ids[id]=ml;			
			readMatrix(ml);
		}
		scanf("sum %d",&i);
	} 
	return 0;
}
