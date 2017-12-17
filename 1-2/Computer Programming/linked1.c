#include<stdio.h>
#include<stdlib.h>
struct node
{
int data;
struct node *next;
};
// This function prints contents of linked list starting from the given node
void printList(struct node *n)
{

while (n != NULL)
{
printf(" %d ", n->data);
n = n->next;
}
}
void push(struct node **head,int value)
{
struct node *new_node=(struct node*) malloc(sizeof(struct node));
printf("%d \n",new_node);
new_node->data= value;
new_node->next= *head;
*head=new_node;
printf("%d",head);
}
int main()
{
struct node *head = NULL;
push(&head,6);
printList(head);
return 0;
}
