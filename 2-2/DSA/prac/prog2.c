#include <stdio.h>
#include <stdlib.h>
struct Node {
int ele;
struct Node *next; };

struct list {
int size;
struct Node *first; };

int curheapsize;
int maxheapsize;

void* mymalloc(unsigned int size){
	curheapsize+=size;
	if (curheapsize>maxheapsize){
		maxheapsize=curheapsize;
	}
	return malloc(size);
}
void memProf(){
	printf("%d\t%d\n",curheapsize,maxheapsize);
}
void myfree(void *ptr){
	curheapsize-=sizeof(ptr);
	free(ptr);
}
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
			struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
			new->ele=val;
			head->first=new;
			head->size++;
		}
		else {
			struct Node *ptr = head->first;
			while(ptr->next!=NULL){
				ptr=ptr->next;
			}
			struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
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
		struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
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
	struct Node *n  ;
	scanf("%d",&count);
	if (count==0){
		return;
	}
	struct Node *ptr = head->first;
	while(ptr!=NULL && i!=count){
		n=ptr;
		ptr=ptr->next;
		myfree(n);
		i++;
	}
	head->first=ptr->next;
	myfree(ptr);
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

void mergefifo(struct list *head1,struct list *head2,struct list *head3){
	struct Node *ptr1 = head1->first;
	struct Node *ptr2 = head2->first;
	struct Node *ptr3 = head3->first;
	while(ptr1!=NULL && ptr2!=NULL){
		if (ptr1->ele <= ptr2->ele){
			if (head3->size==0){
				struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
				new->ele=ptr1->ele;
				new->next=NULL;
				ptr3=new;
				head3->first=ptr3;
				head3->size++;
			}
			else {
				struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
				new->ele=ptr1->ele;
				new->next=NULL;
				ptr3->next=new;
				head3->size++;
				ptr3=new;
			}
			ptr1=ptr1->next;
		}
		else if (ptr2->ele < ptr1->ele){
			if (head3->size==0){
				struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
				new->ele=ptr2->ele;
				new->next=NULL;
				ptr3=new;
				head3->first=ptr3;
				head3->size++;
			}
			else {
				struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
				new->ele=ptr2->ele;
				new->next=NULL;
				ptr3->next=new;
				head3->size++;
				ptr3=new;
			}
			ptr2=ptr2->next;
		}
	}
	if (ptr1==NULL){
		while(ptr2!=NULL){
			struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
			new->ele=ptr2->ele;
			new->next=NULL;
			ptr3->next = new;
			ptr3=new;
			ptr2=ptr2->next;
		}
	}
	else if(ptr2==NULL){
		while(ptr1!=NULL){
			struct Node *new = (struct Node *)mymalloc(sizeof(struct Node));
			new->ele=ptr1->ele;
			new->next=NULL;
			ptr3->next = new;
			ptr3=new;
			ptr1=ptr1->next;
		}
	}
	traverse(head3);
	
}

void mergelist(struct list *head1,struct list *head2,struct list *head3){
	struct Node *ptr1 = head1->first;
	struct Node *ptr2 = head2->first;
	struct Node *ptr3 = head3->first;
	
	while(ptr1!=NULL && ptr2!=NULL){
		if (ptr1->ele <= ptr2->ele){
			if (head3->size==0){
				ptr3=ptr1;
				head3->first=ptr3;
				head3->size++;
			}
			else {
				ptr3->next=ptr1;
				head3->size++;
				ptr3=ptr3->next;
			}
			ptr1=ptr1->next;
		}
		else if (ptr2->ele < ptr1->ele){
			if (head3->size==0){
				ptr3=ptr2;
				head3->first=ptr3;
				head3->size++;
			}
			else {
				ptr3->next=ptr2;
				head3->size++;
				ptr3=ptr3->next;
			}
			ptr2=ptr2->next;
		}
	}
	if (ptr1==NULL){
		ptr3->next = ptr2;
	}
	else if(ptr2==NULL){
		ptr3->next = ptr1;
	}
	traverse(head3);
	
}
	
int main(){
	int no;
	scanf("%d",&no);
	struct list *head1 = (struct list *)mymalloc(sizeof(struct list));
	struct list *head2 = (struct list *)mymalloc(sizeof(struct list));
	struct list *head3 = (struct list *)mymalloc(sizeof(struct list));
	head1->first=NULL;
	head1->size=0;
	head2->first=NULL;
	head2->size=0;
	head3->first=NULL;
	head3->size=0;
	int count=0;
	while( no!=-1){
		if (no==0){
			if (count==0){
				create(head1);
				count++;
			}
			else if (count==1){
				create(head2);
				count--;
			}
		}
		else if (no==1){
			add(head1);
		}
		else if (no==2){
			delete(head1);
		}
		else if (no==3){
			isEmpty(head1);
		}
		else if (no==4){
			traverse(head1);
		}
		else if (no==6){
			mergelist(head1,head2,head3);
		}
		else if (no==5){
			mergefifo(head1,head2,head3);
		}
		else if (no==7){
			memProf();
		}
		
		scanf("%d",&no);
	}
}
