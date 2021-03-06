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

void insertcycle(struct list * head){
	struct Node *ptr = head->first;
	int n;
	scanf("%d",&n);
	int count=1;
	while(count!=n){
		ptr=ptr->next;
		count++;
	}
	struct Node *ptr2 = head->first;
	while (ptr2->next!=NULL){
		ptr2=ptr2->next;
	}
	ptr2->next = ptr;
}

void hascycle(struct list * head){
	if (head->size==0){
	printf("0\n");
	return;
	}
	struct Node *hare = head->first->next;
	struct Node *tortoise = head->first->next->next;
	while (hare->next !=NULL && tortoise->next !=NULL){
		if(hare == tortoise){
			printf("1\n");
			return;
		}
		hare=hare->next;
		tortoise = tortoise->next->next;
	}
	printf("0\n");
	/* if (flag==1){
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
	}*/
	
	return;
}

void traversegeneric(struct list *head){
	if (head->size==0){
	printf("-2\n");
	return;
	}
	struct Node *hare = head->first->next;
	struct Node *tortoise = head->first->next->next;
	int flag=0;
	while (hare->next !=NULL && tortoise->next !=NULL){
		if(hare == tortoise){
			flag=1;
			break;
		}
		hare=hare->next;
		tortoise = tortoise->next->next;
	}
	if (flag==1){
		struct Node *hare2 = head->first;
		while(hare2!=hare){
			printf("%d\t",hare2->ele);
			hare = hare->next;
			hare2 = hare2->next;
		}
		printf("%d\t",hare2->ele);
		hare2=hare2->next;
		while(hare2!=hare){
			printf("%d\t",hare2->ele);
			hare2 = hare2->next;
		}
		printf("-2\n");
		return;
	}
	else {
		traverse(head);
	}
	
}


void destroygeneric(struct list *head){
	head->first = NULL;
	head->size=0;
	traverse(head);  
}



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
		else if (n==3){
			insertcycle(head);
		}
		else if (n==4){
			hascycle(head);
		}
		else if (n==5){
			traversegeneric(head);
		}
		else if (n==6){
		destroygeneric(head);
		}
		scanf("%d",&n);
	}
	return 0;
}

