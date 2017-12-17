#include<stdio.h>
#include<stdlib.h>
#define showcase_size 10
typedef enum
{PINK=5,BROWN,WHITE} color;

typedef struct
{
int bear_id;
float bear_cost;
color bear_color;
} teddy_bear;

typedef struct node
{
teddy_bear tb;
struct node *next;
} NODE;

typedef struct node *LINK;

typedef struct
{
LINK first;
int size;
} LIST;


LIST create(LIST sl)
{
sl.first=NULL;
sl.size=0;
return sl;
}

LINK take(LINK n)
{
printf("enter id");
scanf("%d",n->tb.bear_id);
printf("enter cst");
scanf("%f",n->tb.bear_cost);
printf("enter colo");
scanf("%d",n->tb.bear_color);
return n;
}



int main()
{
LIST sl;
sl=create(sl);
int n,i;
printf("no.");
scanf("%d",n);
LINK new_node=(LINK *)malloc(n*sizeof(NODE));
for(i=0;i<n;i++)
{
new_node+i = take(new_node+i);
new_node[i].next=sl.first;
sl.first=(new_node+i);
sl.size++;
}
}
