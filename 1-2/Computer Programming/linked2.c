#include<stdio.h>
#include<stdlib.h>
typedef struct node NODE;
typedef NODE *LINK;
struct node
{
int data;
LINK next;
};
typedef struct
{
LINK head;
int size;
}LIST;


LIST push(LIST sl,int value)
{
LINK new_node=(LINK) malloc(sizeof(NODE));
new_node->data= value;
new_node->next= sl.head;
sl.head=new_node;
sl.size++;
return (sl);
}


void print(struct list sl) 
{
LINK temp;
temp=sl.head;
while (temp!=NULL)
{
printf("%d %d \n",temp->data,temp->next);
temp=temp->next;
}
}



int main()
{
struct list sl;
sl.size=0;
sl.head=NULL;
//struct node *first;
//first= (struct node *)malloc(sizeof(struct node));
sl = push(sl,6);
sl = push(sl,7);
print(sl);
}
