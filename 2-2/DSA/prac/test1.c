#include <stdio.h>
#include <stdlib.h>
struct Node {
int ele;
struct Node *next; };

struct list {
int size;
struct Node *first; };

int main(){
	struct Node n[10];
	int i;
	for (i=0;i<10;i++){
		n[i].ele = 2;
		n[i].next=&n[i+1];
	}
	for (i=0;i<10;i++){
		printf("%d",n[i].ele);
	}
return 0;
}
