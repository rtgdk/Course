#include<stdio.h>

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
void read_classInfobyRef(std *s,int cl_no,int nb)
{
int m,k,na;
(s+cl_no)->booklist=(struct text_book*)malloc(nb*sizeof(struct text_book));	
(s+cl_no)->no_books=nb;
for(m=0;m<nb;m++)
{
printf("Enter name:");
	scanf("%s",(s+cl_no)->booklist[m].name);
printf("Enter bid:");
	scanf("%d",&(s+cl_no)->booklist[m].bid);
printf("Enter price:");
	scanf("%f",&(s+cl_no)->booklist[m].price);
printf("Enter number of authors:");
	scanf("%d",&(s+cl_no)->booklist[m].numaut);
na=(s+cl_no)->booklist[m].numaut;
printf("Enter name of authors:");
	for(k=0;k<na;k++)
	scanf("%s",(s+cl_no)->booklist[m].autlist[k]);
}	
}

void print_classInfo(std s,int cl_no)
{
int m,k,na;
printf("Enter the number of textbooks: %d",s.no_books);
for(m=0;m<s.no_books;m++)
{
printf("Name: %s",s.booklist[m].name);
printf("Bid: %d",s.booklist[m].bid);
printf("Price: %f",s.booklist[m].price);
printf("Number of authors: %d",s.booklist[m].numaut);
na= s.booklist[m].numaut;
printf("Authors List");
for(k=0;k<na;k++)
printf("%s",s.booklist[m].autlist[k]);
}
}
int main(void) 
{
	int nc,ns,i,j;
	std *s;
	printf("enter number of classes\n");
	scanf("%d",&nc);
	s=(std*)malloc(nc*sizeof(std));
	for(i=0;i<nc;i++)
	{
		printf("enter number of text_books for %d standard\n",i);
		scanf("%d",&ns);
		read_classInfobyRef(s,i,ns);
}
for(i=0;i<nc;i++);
{
print_classInfo(*(s+i),i);
}

	return 0;
}


