#include <stdio.h>
#include <stdlib.h>
void mergeAux(int a1[],int s1,int e1,int a2[],int s2,int e2,int a3[],int s3,int e3){
	int i;
	if(s1>e1){
		for(i=0;i<=e2-s2;i++){
			a3[i+s3]=a2[i+s2];
		}
		return;
	}
	else if(s2>e2){
		for(i=0;i<=e1-s1;i++){
			a3[i+s3]=a1[i+s1];
		}
		return;
	}
	if(a1[s1]<=a2[s2]){
		a3[s3]=a1[s1];
		mergeAux(a1,s1+1,e1,a2,s2,e2,a3,s3+1,e3);
	}
	else{
		a3[s3]=a2[s2];
		mergeAux(a1,s1,e1,a2,s2+1,e2,a3,s3+1,e3);
	}
}
void mergeSort(int a[],int s,int e){
	int i,mid=(s+e)/2;
	if(s==e){
		return;
	}
	int b[e-s+1];
	mergeSort(a,s,mid);
	mergeSort(a,mid+1,e);
	mergeAux(a,s,mid,a,mid+1,e,b,0,e-s);
	for(i=0;i<=e-s;i++){
		a[i+s]=b[i];
	}
}

int main(){
	int n,i;
	scanf("%d",&n);
	int a[n];
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}
	mergeSort(a,0,n-1);
	for(i=0;i<n;i++){
		printf("%d\n",a[i]);
	}
	//mergeAux()
	return 0;		
}
