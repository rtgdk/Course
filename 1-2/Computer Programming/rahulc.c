
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct book;
typedef struct book BOOK;
typedef BOOK *link;

struct book
{
int book_n;
float bookprice;
char name[15];

link next;
};

typedef struct
{
link head;
int size;

}list;

list creat();

list insert(list l);

void print(list l);

void search(int x,list l);


void sort(list l);

int main()
{
int i,k,T;
list sl;
sl=creat();

printf("how many book detail you want to insert\n");
scanf("%d",&i);
while(i>0)
 {
   printf("enter the detail's of the book i.e.\n booknumber\n bookprice\nname of the book\n");
   sl=insert(sl);
   i--;
  
 }
print(sl);


/*printf("which booknumber you want to search\n");
scanf("%d",&k);

search(k,sl);

printf("which booknumber you want to search\n");
scanf("%d",&T);

search(T,sl);
*/

sort(sl);

return 0;
}

list creat()
 {
   list l;
   l.head=NULL;
   l.size=0;

   return l;
 }
list insert(list l)
 {
   link b;
   b=(link)malloc(1*(sizeof(BOOK)));
   scanf("%d%f%s",&(b->book_n),&(b->bookprice),&(b->name));
   b->next=l.head;
   l.head=b;
  
   return l;

 }

void print(list l)
 {
   link temp;
   temp=l.head;
  
   while(temp!=NULL)
    {
      printf("%d %s %f \n",temp->book_n,temp->name,temp->bookprice);
     
      temp=temp->next;
     
    }

 
 }

void search(int x,list l)
 {
   link temp;

   temp=l.head;

  
   while((temp->book_n!=x))
    {
      temp=temp->next;
      if(temp!=NULL)
       {
        printf("entered book number is not found in the list\n");
        
        return ;
       }

    }  
 
   
     if((temp->book_n)==x)
     {
      printf("FOUND!!!\n");
      printf("%d\t%s\t%f",temp->book_n,temp->name,temp->bookprice);
  
     }
   
   
 }


void sort(list l)

 {
  int i=100;
  link temp;
  link prev;
  link flag;
  prev=l.head;
  temp=l.head->next;
  printf("let's sort them in increastng order\n");
 
while(i>0)
{ 

 prev=l.head;
  temp=l.head->next;

  while(temp!=NULL)
 { 
 if((temp->book_n)>(prev->book_n))
    {
      temp=temp->next;
      prev=prev->next;   
   
    }


  else
  {
  prev->next=temp->next;
  temp->next=prev;
 
   break;
  }
  
}


i--;
}

printf("sdbfkl\n");
flag=l.head;
while(flag!=NULL)
 {
    printf("%d %s %f \n",flag->book_n,flag->name,flag->bookprice);
     
      flag=flag->next;
 }



}




