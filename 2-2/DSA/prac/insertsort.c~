#include <stdio.h>
#include <stdlib.h>

void insertinorder(int b, int a[], int n){
	if (n==0){
		return;}
	int i,temp;
	for (i=0;i<=n;i++){
		if(b<a[i]){
			temp=a[i];
			a[i]=b;
			b=temp;
			a[n]=b;
		}
	}
	for (i=0;i<=4;i++){
		printf("%d",a[i]);
	}
	printf("\n");
	return;
}
void insertSort(int a[], int n){
	if (n==0){ 
	return;
	}
	insertSort(a,n-1);
	insertinorder(a[n-1],a,n-1);
	return;
	}
	
int main(){
	int a[5];
	int i;
	for (i=0;i<=4;i++){
		scanf("%d",&a[i]);
	}
	insertSort(a,5);
	for (i=0;i<=4;i++){
		printf("%d",a[i]);
	}
}
