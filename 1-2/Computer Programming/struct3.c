#include <stdio.h>
struct class
{
int no_books;
struct text_book *booklist;
};
typedef struct class std;
struct text_book
{
char name[10];
int bid;
float price;
int numaut;
char autlist[5][10];
};
int read_classInfobyRef(std *s,int cl_no,int nb);
void print_classInfo(std s,int cl_no);
std read_classInfobyVal(std s,int cl_no,int nb);
void print_allInfo(std *s, int nc);




int main()
{
int nc,ns,i,j;
std *s;
printf("enter number of classes\n");
scanf("%d",&nc);
s= (std *)malloc(nc*sizeof(std));
for(i=0;i<nc;i++)
{
printf("enter number of text_books for %d standard\n",i);
scanf("%d",&ns);
s[i]=read_classInfobyVal(*(s+i),i,ns); //read_classInfobyRef(s,i,ns)
}
//for(i=0;i<nc;i++)
//{
//print_classInfo(*(s+i),i);
//}
print_allInfo(s,nc);

}




int read_classInfobyRef(std *s,int cl_no,int nb)
{
(s+cl_no)->no_books = nb;
struct text_book *book;
(s+cl_no)->booklist=(struct text_book *)malloc(nb*sizeof(struct text_book));
int i,j;
for (i=0;i<nb;i++)
{
printf("enter book sssname %d",i);
scanf("%s",&(((s+cl_no)->booklist+i)->name)); //s[cl_no].
printf("enter book id");
scanf("%d",&(s+cl_no)->booklist[i].bid);
printf("enter book price");
scanf("%f",&(s+cl_no)->booklist[i].price);
printf("enter no of authors");
scanf("%d",&s[cl_no].booklist[i].numaut);
printf("enter book author ");
for(j=0;j<(s[cl_no].booklist[i].numaut);j++)
scanf("%s",&(s[cl_no].booklist[i].autlist[j]));
}
return 0;
}
void print_classInfo(std s,int cl_no)
{
	int i,j;
	printf("Class no: %d \n",cl_no);
	printf("No. of books %d \n",s.no_books);
	for (i=0;i<s.no_books;i++)
	{
	printf("book no: %d \n",i);
	printf("name : %s \n",s.booklist[i].name);
	printf("id %d \n",s.booklist[i].bid);
	printf("price %f \n",s.booklist[i].price);
	printf("numaut %d \n",s.booklist[i].numaut);
	for (j=0;j<(s.booklist[i].numaut);j++)
	{
	printf("author  %s \n",s.booklist[i].autlist[j]);
	}
	}
}


std read_classInfobyVal(std s,int cl_no,int nb)
{
s.no_books = nb;
s.booklist=(struct text_book *)malloc(nb*sizeof(struct text_book));
int i,j;
for (i=0;i<nb;i++)
{
printf("enterssss book name %d",i);
scanf("%s",s.booklist[i].name); //s[cl_no].
printf("enter book id");
scanf("%d",&s.booklist[i].bid);
printf("enter book price");
scanf("%f",&s.booklist[i].price);
printf("enter no of authors");
scanf("%d",&s.booklist[i].numaut);
printf("enter book author ");
for(j=0;j<(s.booklist[i].numaut);j++)
scanf("%s",(s.booklist[i].autlist[j]));
}
return (s);
}



void print_allInfo(std *s, int nc)
{
int i,j,k;
for (i=0;i<nc;i++)
{
printf("%d %d",i,s[i].no_books);
for (j=0;j<s[i].no_books;j++)
{
	printf("book no: %d \n",j);
	printf("name : %s \n",s[i].booklist[j].name);
	printf("id %d \n",s[i].booklist[j].bid);
	printf("price %f \n",s[i].booklist[j].price);
	printf("numaut %d \n",s[i].booklist[j].numaut);
	for (k=0;k<(s[i].booklist[j].numaut);k++)
	{
	printf("author  %s \n",s[i].booklist[i].autlist[k]);
	}
}
}
}




