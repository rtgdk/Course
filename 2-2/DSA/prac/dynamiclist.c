#include <stdio.h>
#include <stdlib.h>
struct Node {
int ele;
struct Node *next;
};

struct list {
int size;
struct Node *first;
};


void traverse(struct list *head){
	struct Node *ptr = head->first;
	while (ptr!=NULL){
		printf("%d\t",ptr->ele);
		ptr=ptr ->next ;
	}
	printf("-2\n");
	return;
}


void create(struct list * head,int ele){
	if (head->size == 0){
		struct Node *new = (struct Node *)malloc(sizeof(struct Node));
		new->next = head->first;
		new->ele = ele;
		head->first = new;
		head->size ++;	
		return;
	}
	struct Node *ptr = head->first;
	while (ptr->next!=NULL){
		ptr=ptr->next;
	}
	struct Node *new = (struct Node *)malloc(sizeof(struct Node));
	new->next = NULL;
	new->ele = ele;
	ptr->next = new;
	head->size++;
}
void destroy(struct list * head){
	if (head->size==0){
		printf("-3\n");
		return;
	}
	struct Node *ptr = head->first;
	while (ptr!=NULL){
		ptr=ptr->next;
		free(head->first);
		head->first=ptr;
		head->size --;
	}
	traverse(head);
}




/*void createcycle(struct list *head){
	struct Node *ptr = head->first;
	struct Node *ptr2 = head->first;
	while (ptr->next!=NULL){
		ptr=ptr->next;
	}
	ptr->next = ptr2->next;
}

void checkcycle(struct list *head){
	struct Node *hare = head->first;
	struct Node *tortoise = head->first->next;
	while (hare->next !=NULL && tortoise->next !=NULL){
		if(hare == tortoise){
			printf("Cyclic list");
			return;
		}
		hare=hare->next;
		tortoise = tortoise->next->next;
	}
	printf("Not Cyclic list");
	return;
}
*/
int main(){
	struct list *head = (struct list *)malloc(sizeof(struct list));
	head->size=0;
	head->first=NULL;
	int n;
	int ele;
	scanf("%d",&n);
	while (n!=-1){
		if (n==0){
			scanf("%d",&ele);
			while (ele!=-1){
				create(head,ele);
				scanf("%d",&ele);
			}
			traverse(head);
		}
		else if (n==1){
			traverse(head);
		}
		else if (n==2){
			destroy(head);
		}
		scanf("%d",&n);
	}
	return 0;
}

