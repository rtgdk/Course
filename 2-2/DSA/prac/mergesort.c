#include <stdio.h>
#include <stdlib.h>

void mergeunion(int a[],int st,int en,int c[],int st2,int en2,int b[],int st3, int en3){
	if (st > en){
		int i;
		for (i=st2;i<=en2;i++){
			b[st3] = c[i];
			st3++;
			 }
			 return;
		 }
	else if (st2 > en2){
		int i;
		for (i=st;i<=en;i++){
			b[st3] = a[i];
			st3++;
			 }
			return;
		 }
	else if (a[st]<=c[st2]){
		b[st3]=a[st];
		mergeunion(a,st+1,en,c,st2,en2,b,st3+1,en3) ;}
	else {
		b[st3]=c[st2];
		mergeunion(a,st,en,c,st2+1,en2,b,st3+1,en3) ;}
}
void merge(int a[],int st,int en){
	int mid = (st+en)/2;
	int i;	
	if (en-st!=0){
		int b[en-st+1];
		merge(a,st,mid);
		merge(a,mid+1,en);
		mergeunion(a,st,mid,a,mid+1,en,b,0,en-st);
		for (i=0;i<=en-st;i++){
			a[i+st]=b[i];
		}
	}
	else {
		return; }	
	return;
}

int main(){

int n;
scanf("%d",&n);
int a[n];
int i;
for (i=0;i<n;i++){
	scanf("%d",&a[i]);
}
merge(a,0,n-1);
for (i=0;i<n;i++){
	printf("%d\n",a[i]);
}
return 0;

}
