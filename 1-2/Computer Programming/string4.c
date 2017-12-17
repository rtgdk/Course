#include<stdio.h>
#include<stdlib.h>

struct text_book
{
char name[30];
int bid;
float price;
int numaut;
char autlist[5][10];
};

struct class
{
int no_books;
struct text_book *booklist;
};
typedef struct class std;

int ReadClassInfoByRef(std *s, int cn, int nb)
{
    int i,j, k;
    s->no_books = nb;
    s->booklist = (struct text_book*) malloc(sizeof(struct text_book)*nb);
    for(j = 0; j < nb; j++)
    {
        printf("Enter book name: ");
        scanf(" %[^\n]", &((s->booklist+j)->name));
        printf("Enter identification number: ");
        scanf("%d", &((s->booklist+j)->bid));
        printf("Enter cost of the book: ");
        scanf("%f", &((s->booklist+j)->price));
        printf("Enter number of authors(max 5): ");
        scanf("%d", &((s->booklist+j)->numaut));
        for(k = 0; k < (s->booklist+j)->numaut; k++)
        {
            printf("Enter name of author-%d name: ",(k+1));
            scanf(" %[^\n]", &((s->booklist+j)->autlist[k]));
        }
    }
    return 0;
}

int ReadClassInfoByVal(std s, int cn, int nb)
{
    int j, k;
    s.no_books = nb;
    s.booklist = (struct text_book*) malloc(sizeof(struct text_book)*nb);
    for(j = 0; j < nb; j++)
    {
        printf("Enter book name: ");
        scanf(" %[^\n]", &((s.booklist+j)->name));
        printf("Enter identification number: ");
        scanf("%d", &((s.booklist+j)->bid));
        printf("Enter cost of the book: ");
        scanf("%f", &((s.booklist+j)->price));
        printf("Enter number of authors(max 5): ");
        scanf("%d", &((s.booklist+j)->numaut));
        for(k = 0; k < (s.booklist+j)->numaut; k++)
        {
            printf("Enter name of author-%d name: ",(k+1));
            scanf(" %[^\n]", &((s.booklist+j)->autlist[k]));
        }
    }
    return 0;
}

int print_classInfo(std s, int cn)
{
    int i, j;
    printf("\n-------------------------------------------------------------------------\n");
    printf("In class %d, we have a total of %d books.\n", cn, s.no_books);
    for(i = 0; i < s.no_books; i++)
    {

        printf("Book name: %s\n", (s.booklist+i)->name);
        printf("Identification number: %d\n",(s.booklist+i)->bid);
        printf("Cost of the book: %f\n",(s.booklist+i)->price);
        for(j = 0; j < (s.booklist+i)->numaut; j++)
        {
            printf("Author %d is: %s\n",(j+1),(s.booklist+i)->autlist[j]);
        }
    }
    return 0;
}

int print_allInfo(std *s,int nc)
{
	int i, j, k;
	
	for(i = 0; i < nc; i++)
	{	
		printf("\n-------------------------------------------------------------------------\n");
		printf("In class %d, we have a total of %d books.\n", nc, (s+i)->no_books);
    	for(j = 0; i < (s+i)->no_books; i++)
    	{
        	printf("Book name: %s\n", ((s+i)->booklist+j)->name);
        	printf("Identification number: %d\n",((s+i)->booklist+j)->bid);
        	printf("Cost of the book: %f\n",((s+i)->booklist+j)->price);
        	for(k = 0; k < (((s+i)->booklist+j)->numaut); k++)
        	{
            	printf("Author %d is: %s\n",(j+1),((s+i)->booklist+j)->autlist[k]);
        	}
    	}
    }
    return 0;
}			 

int main()
{
    int nc,ns,i,j;
    std *s;
    printf("Enter number of classes\n");
    scanf("%d", &nc);
    s = (std*) malloc(nc*sizeof(std));
    for(i = 1; i <= nc; i++)
    {
        printf("Enter the number of textbooks for %d standard: ", i);
        fflush(stdin);
        scanf("%d", &ns);
        ReadClassInfoByRef(s+i-1, i, ns);
       	//ReadClassInfoByVal(*s, i, ns);
    }
    for(i = 1; i <= nc; i++)
    {
       print_classInfo(*s, i);
    }
    //print_allInfo(s, nc);
   return 0;
}
