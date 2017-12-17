#include<stdio.h>
#include<stdlib.h>
#define SIZE 10

void swap(int *a,int *b) {
int temp=*a;
*a=*b;
*b=temp;
}

void min_Heapify(int *a,int size,int index) {
int right,left,smallest;
left=2*index+1;
right=2*index+2;
if(left<size && a[left]<a[index])
	smallest=left;
else
	smallest=index;
if(right<size && a[right]<a[smallest])
	smallest=right;
if(smallest != index)
{
	swap(&a[smallest],&a[index]);
	min_Heapify(a,size,smallest);
}
}

void build_Min_Heap(int *a,int size) {
int i;
for(i=size/2-1;i>=0;i--) {
	min_Heapify(a,size,i);
}
}

void heapsort(int *a,int size) {
int i;
build_Min_Heap(a,size);
for(i=size-1;i>0;i--) {
	swap(&a[0],&a[i]);
	min_Heapify(a,i,0);
}
}

int insert(int *a,int b,int size) {
int *t=(int*)realloc(a,sizeof(int)*(size+1));
if(t==NULL)
{
	printf("ERROR\n");
	exit(0);
}
else
	a=t;
a[size]=b;
int i=(size-1)/2;
while(i>=0) {
	min_Heapify(a,size+1,i);
	if(i==0)
		break;
	i=(i-1)/2;
}
return size+1;
}

main() {
int i;
int *a=(int*)malloc(sizeof(int)*SIZE);
FILE *fp=fopen("input","r");
for(i=0;i<SIZE;i++) {
	fscanf(fp,"%d",&a[i]);
}
//a[]={23,78,1,4,0,45,26,78,21,34};//,56,65,34,23,67,90,60,12,34,43};
for(i=0;i<SIZE;i++)
	printf("%3d",a[i]);
printf("\n");
/*double start,end;
struct timeval *t;
gettimeofday(t,NULL);
start=(double)t->tv_sec + (double)(t->tv_usec/1000000.0);
printf("%lf\n",start);*/
heapsort(a,SIZE);
/*gettimeofday(t,NULL);
end=(double)t->tv_sec + (double)(t->tv_usec/1000000.0);
printf("%lf\n",end);
printf("Execution time = %lf\n",end-start);*/
int size=SIZE;
build_Min_Heap(a,size);
size=insert(a,45,size);
heapsort(a,size);
for(i=0;i<size;i++)
	printf("%3d",a[i]);
printf("\n");
}
