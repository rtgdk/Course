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
	printf("\n");
	return;
}
void insertinfront(struct list *head,int ele){
	struct Node *new = (struct Node *)malloc(sizeof(struct Node));
	new->next = head->first;
	new->ele = ele;
	head->first = new;
	head->size ++;
	traverse(head);	
}

void insertatend(struct list * head,int ele){
	if (head->size == 0){
		insertinfront(head,ele);
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
	traverse(head);
}
void deletefromfront(struct list * head){
	if (head->size==0){
		printf("-2\n");
		return;
	}
	int ele = head->first->ele;
	head->first = head->first->next;
	head->size --;
	printf("%d\n",ele);
}

void deletefromend(struct list * head){
	if (head->size == 0){
		printf("-2\n");
		return;
	}
	else if (head->size == 1){
		deletefromfront(head);
		return;
	}
	else if (head->size == 2){
		int ele = head->first->next->ele;
		head->first->next=NULL;
		head->size--;
		printf("%d\n",ele);
		return;
	}
	struct Node *ptr = head->first;
	while (ptr->next->next!=NULL){
		ptr=ptr->next;
	}
	int ele = ptr->next->ele;
	ptr->next = NULL;
	head->size--;
	printf("%d\n",ele);
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
			insertinfront(head,ele);
		}
		else if (n==1){
			scanf("%d",&ele);
			insertatend(head,ele);
		}
		else if (n==2){
			deletefromfront(head);
		}
		else if (n==3){
			deletefromend(head);
		}
		else if (n==4){
			traverse(head);
		}
		/*else if (n==5){
			createcycle(head);
		}*/
		scanf("%d",&n);
	}
	return 0;
	//checkcycle(head);
	

}

