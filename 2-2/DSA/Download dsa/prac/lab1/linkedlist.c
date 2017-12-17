#include "linkedlist.h"

void insertFirst(struct linkedList * head, int ele){
	struct node *new = (struct node *)malloc(sizeof(struct node));
	new->element =ele;
	new->next = head->first;
	head->first = new;
	head->count ++;
	return;
}

struct node* deleteFirst(struct linkedList * head){

// exercise to implement this operation.
	head->first = head->first->next;
	head->count --;
	return;

}

void printList (struct linkedList * head){
	struct node *ptr = head->first;
	while(ptr !=NULL){
		printf("%d ->",ptr->element);
		ptr = ptr->next;
	}

}
