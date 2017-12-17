#include <stdio.h>
#include <stdlib.h>

int pivot(int A[],int p, int q){
	int i=p-1;
	int j=p;
	int x=A[q];
	int temp;
	for(j;j<q;j++){
		if (A[j]<=x){
			i++;
			temp=A[i];
			A[i]=A[j];
			A[j]=temp;
		}
	}
	temp=A[i+1];
	A[i+1]=A[q];
	A[q]=temp;
	return i+1;
}

void quicksort(int A[], int p,int q){
	if (p<q){
		int r = pivot(A,p,q);
		quicksort(A,p,r-1);
		quicksort(A,r+1,q);
	}	
}

int main(){
	int A[] ={1,23,5,8,11,234};
	quicksort(A,0,5);
	int i=0;
	for(i;i<6;i++){
	printf("%d ",A[i]);
	}
}
