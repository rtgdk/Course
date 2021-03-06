#include <stdio.h>
#include <stdlib.h>
struct Node {
int n;
int ele;
struct Node *next;
};

struct list {
int size;
struct Node *first;
};


void create(struct list *head,int n,int ele,struct list *cnode){
	int flag=0;
	if (head->size == 0){
		struct Node *new = (struct Node *)malloc(sizeof(struct Node));
		new->next = head->first;
		new->ele = ele;
		new->n = n;
		head->first = new;
		head->size ++;	
		cnode->first = new;
		return;
	}
	struct Node *ptr = head->first;
	while (ptr->next!=NULL){
		if (ptr->n==n){
			flag =1;
			break;
		}
		ptr=ptr->next;
	}
	if (flag==1){
		cnode->first->next = ptr;
	}
	else {
		struct Node *new = (struct Node *)malloc(sizeof(struct Node));
		new->next = NULL;
		new->ele = ele;
		new->n=n;
		ptr->next = new;
		cnode->first=new;
		head->size++;
	}
}



void hascycle(struct list * head){
	if (head->size==0){
		printf("0\n");
		return;
	}
	struct Node *hare = head->first;
	struct Node *tortoise = head->first;
	int flag=0;
	while (hare->next!=NULL && tortoise->next!=NULL && tortoise->next->next!=NULL ){
		hare=hare->next;
		tortoise= tortoise->next->next;
		if(hare == tortoise){
			flag=1;
			break;
		}
	}
	if (flag==1){
		hare=hare->next;
		int count = 1 ;
		while(hare!=tortoise){
			hare = hare->next;
			count++;
		}
		printf("%d\n",count);
		return;
	}
	else if (flag==0){
		printf("0\n");
		return;
	}
	
}
int main(){
	struct list *head = (struct list *)malloc(sizeof(struct list));
	struct list *cnode = (struct list *)malloc(sizeof(struct list));
	head->size=0;
	head->first=NULL;
	int n;
	int ele;
	scanf("%d",&n);
	while (n!=-1){
		scanf("%d",&ele);
		create(head,n,ele,cnode);
		//traverse(head);
		scanf("%d",&n);
	}
	hascycle(head);	
	return 0;
}

