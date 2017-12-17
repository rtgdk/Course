#include <stdio.h>
#include <stdlib.h>
struct Node {
int ele;
struct Node *next; };

struct list {
int size;
struct Node *first; };


void traverse(struct list *head){
	if (head->first==NULL){
		printf("-1\n");
		return;
	}
	struct Node *ptr = head->first;
	while(ptr!=NULL){
		printf("%d\t",ptr->ele);
		ptr=ptr->next;
	}
	printf("\n");
	return;
}

void create(struct list *head){
	int n;
	scanf("%d",&n);
	int i;
	int val;
	for (i=0;i<n;i++){
		scanf("%d",&val);
		if (head->size==0){
			struct Node *new = (struct Node *)malloc(sizeof(struct Node));
			new->ele=val;
			head->first=new;
			head->size++;
		}
		else {
			struct Node *ptr = head->first;
			while(ptr->next!=NULL){
				ptr=ptr->next;
			}
			struct Node *new = (struct Node *)malloc(sizeof(struct Node));
			new->ele=val;
			ptr->next=new;
			head->size++;
		}
	}
	traverse(head);
}

void add (struct list *head){
	int val;
	struct Node *ptr = head->first;
	while(ptr->next!=NULL){
		ptr=ptr->next;
	}
	scanf("%d",&val);
	while (val!=-1){
		struct Node *new = (struct Node *)malloc(sizeof(struct Node));
		new->ele=val;
		ptr->next=new;
		ptr=ptr->next;
		head->size++;
		scanf("%d",&val);
	}
	traverse(head);
}

void delete(struct list *head){
	int count;
	int i=1;
	scanf("%d",&count);
	if (count==0){
		return;
	}
	struct Node *ptr = head->first;
	while(ptr!=NULL && i!=count){
		ptr=ptr->next;
		i++;
	}
	head->first=ptr->next;
	head->size-=count;
	traverse(head);
}

int isEmpty(struct list *head){
	if (head->first==NULL){
		printf("1\n");
	}
	else {
		printf("0\n");
	}
}

	
int main(){
	int no;
	scanf("%d",&no);
	struct list *head = (struct list *)malloc(sizeof(struct list));
	head->first=NULL;
	head->size=0;
	while( no!=-1){
		if (no==0){
			create(head);
		}
		else if (no==1){
			add(head);
		}
		else if (no==2){
			delete(head);
		}
		else if (no==3){
			isEmpty(head);
		}
		else if (no==4){
			traverse(head);
		}
		scanf("%d",&no);
	}
}
