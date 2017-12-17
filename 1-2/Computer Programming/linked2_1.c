#include <stdio.h>
#define showcase_size 10
//Number of TB's which can be accommodated in the showcase.
typedef enum
{PINK=5,BROWN,WHITE} color;
// Three colors of TB's

typedef struct
{
int bear_id;
float bear_cost;
color bear_color;
} teddy_bear;
//Information about a TB
typedef struct node
{
teddy_bear tb;
struct node *next;
} NODE;
typedef struct node *Link;
// Node of a Linked List
typedef struct
{
NODE *first;
int size;
} LIST;

LIST create(LIST sl)
{
  sl.first=NULL;
  sl.size=0;
  return sl;
}

void print(LIST sl)
{
  Link t;
  t=sl.first;
  while(t!=NULL) {
    printf("%d %f %d -->",t->tb.bear_id, t->tb.bear_cost, t->tb.bear_color);
    t=t->next;
  }
  printf("NULL");
  printf("\n");
}

teddy_bear info()
{
  teddy_bear t;
  printf("ID");
  scanf("%d",&t.bear_id);
  printf("cost");
  scanf("%f",&t.bear_cost);
  printf("color");
  scanf("%d",&t.bear_color);
  return t;
}

LIST push(LIST sl,teddy_bear t)
{
  Link r;
  r=(Link)malloc(sizeof(NODE));
  r->tb=t;
  r->next=sl.first;
  sl.size++;
  sl.first= r;
  return sl;
}

void deletelast(LIST sl)
{
  Link t;
  t=sl.first;
  while(t->next->next!=NULL);
  t->next=NULL;
  sl.size--;
  
}


LIST insert_new(LIST sl,teddy_bear new)
{
  if (sl.size>10)
    deletelast(sl);
  sl=push(sl,new);
  return sl;
}

int count(LIST sl,color c)
{
  Link t;
  int f=0;
  t=sl.first;
  while(t!=NULL){
    if (t->tb.bear_color==c)
      f++;
    t=t->next;
  }
  return f;
}

void insert_sorted(LIST sl,teddy_bear t)
{
int f;
f=t->bear_color ;
t=sl.first;
while(t!=NULL){
	if(t->tb.bear_color==f)
	{
	
	}
}
int main()
{
LIST sl;
sl=create(sl);
print(sl);
Link one,two,three;
one= (Link)malloc(sizeof(NODE));
one->tb=info();
sl.first=one;
one->next=NULL;
sl.size++;
print(sl);
teddy_bear t=info();
sl=push(sl,t);
print(sl);
deletelast(sl);
print(sl);
teddy_bear new=info();
sl=insert_new(sl,new);
print(sl);
int no;
no=count(sl,6);
printf("%d",no);
}
