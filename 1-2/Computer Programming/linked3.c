#include<stdio.h>
#include<stdlib.h>
struct node
{
int data;
struct node *next;
};
struct list
{
struct node *head;
int size;
};


struct list push(struct list sl,int value)
{
struct node *new_node=(struct node *) malloc(sizeof(struct node));
new_node->data= value;
new_node->next= sl.head;
sl.head=new_node;
sl.size++;
return (sl);
}


void print(struct list sl) 
{
struct node *temp;
temp=sl.head;
while (temp!=NULL)
{
printf("|%d|-|%d|->",temp->data,temp->next);
temp=temp->next;
}
}

void search(struct list sl,int value)
{
struct node *temp;
temp=sl.head;
int no=1;
while (temp!=NULL)
{
if (temp->data==value)
	{
	printf("Found at %d node",no);
	return;
	}
else
	{
	no++;
	temp=temp->next;
	}
}
printf("Not found");
return;
}


int main()
{
struct list sl;
sl.size=0;
sl.head=NULL;
//struct node *first;
//first= (struct node *)malloc(sizeof(struct node));
sl=push(sl,6);
sl=push(sl,7);
sl=push(sl,8);
print(sl);
search(sl,9);
search(sl,7);

}
