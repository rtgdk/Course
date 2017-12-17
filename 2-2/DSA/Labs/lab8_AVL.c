#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node
{
    char word[100];
    struct node *lchild;
    struct node *rchild;
};

typedef struct node *NODEPTR;

NODEPTR tree;

int height(NODEPTR n)
{
	int a,b;
	if(n==NULL)
		return 0;
	else if(!(n->lchild||n->rchild))
		return 1;
	else
	{
	a=1+height(n->lchild);
	b=1+height(n->rchild);
	if(a>b)
		return a;
	else
		return b;
	}
}

void PrintPreorder(NODEPTR T)
{
    int h,b;
        if(T==NULL)
        {
                return;
        }
        h=height(T);
        b=height(T->lchild) - height(T->rchild);
        printf("%s %d %d\n",T->word,h,b);
        PrintPreorder(T->lchild);
        PrintPreorder(T->rchild);
}

void PrintInorder(NODEPTR T)
{
    int h,b;
        if(T==NULL)
        {
                return;
        }
        h=height(T);
        b=height(T->lchild) - height(T->rchild);

        PrintInorder(T->lchild);
        printf("%s %d %d\n",T->word,h,b);
        PrintInorder(T->rchild);
}


NODEPTR LL(NODEPTR a)
{
 NODEPTR b;

 //printf("Inside LL print preorder 1\n");
 //PrintPreorder(tree);
 //printf("Inside LL\n");
 b=a->lchild;
 //printf("Inside LL print preorder 2\n");
 //PrintPreorder(tree);

  a->lchild=b->rchild;
  b->rchild=a;
  //printf("Inside LL print preorder 3\n");
  //PrintPreorder(tree);

 //printf("Inside LL print preorder 4\n");
 //PrintPreorder(tree);
return b;
}

NODEPTR LR(NODEPTR a)
{
   //  printf("Inside LR\n");
 NODEPTR b,c;
 b=a->lchild;
 c=b->rchild;

 b->rchild=c->lchild;
 a->lchild=c->rchild;

 c->lchild=b;
 c->rchild=a;

 return c;
}

NODEPTR RR(NODEPTR a)
{
     //printf("Inside RR\n");
     //PrintPreorder(a);
  NODEPTR b;
  b=a->rchild;

  a->rchild=b->lchild;
  b->lchild=a;

  return b;
}

NODEPTR RL(NODEPTR a)
{
     //printf("Inside RL\n");
 NODEPTR b,c;
 b=a->rchild;
 c=b->lchild;

 a->rchild=c->lchild;
 b->lchild=c->rchild;

 c->lchild=a;
 c->rchild=b;

 return c;
}



NODEPTR Insert(NODEPTR T,NODEPTR n)
{
	int j,a,b,flag=0;
       // printf("Insert executed\n");
        if(T==NULL)
        {
                NODEPTR temp;
                temp = (NODEPTR)malloc(sizeof(struct node));
                strcpy(temp->word,n->word);
                temp -> lchild = temp -> rchild = NULL;
	 	//printf("temp=%s\n",temp->word);
                return temp;
        }

	j=strcmp(n->word,T->word);
	//printf("j=%d\n",j);
        //printf("j=%d\n",j);

	if(j>=0)
        {
      // printf("Right Insert executed\n");
             	T->rchild = Insert(T->rchild,n);

        }
        else if(j<0)
        {
        //printf("Left Insert executed\n");
             	T->lchild = Insert(T->lchild,n);

        }

    a=height(T->lchild) - height(T->rchild);
    if(a<-1)
        b=strcmp(n->word,T->rchild->word);
    else if(a>1)
        b=strcmp(n->word,T->lchild->word);

    //printf("a=%d,b=%d\n",a,b);
    //printf("T=%s\n",T->word);
 /*   if(flag==1)
        {T=LL(T);flag=0;}
    else if(flag==2)
        {T=LR(T);flag=0;}
    else if(flag==3)
        {T=RL(T);flag=0;}
    else if(flag==4)
        {T=RR(T);flag=0;}*/

    if(b<=0&&a>1)
        T=LL(T);
    else if(b>0&&a>1)
        T=LR(T);
    else if(b<0&&a<-1)
        T=RL(T);
    else if(b>=0&&a<-1)
        T=RR(T);

	/*PrintPreorder(T);
	k=height(T);
	printf("height=%d\n",k);*/

        return T;
}


int main()
{
     	int k=0;
	char arr[100];

     tree= NULL;
     NODEPTR z;
     z = (NODEPTR)malloc(sizeof(struct node));
     z->lchild = z->rchild = NULL;
    // FILE *fp;
     //fp=fopen("data.txt","r");
     while(fscanf(stdin,"%s",arr)!=EOF)
     {
         strcpy(z->word,arr);
	 tree=Insert(tree,z);
	 //printf("Insert_tree preorder\n");
	 //PrintPreorder(tree);
	 //printf("arr=%s\n",arr);
	k=height(tree);
	//printf("height=%d\n",k);
	 //printf("z=%s\n",z->word);
     }
     PrintInorder(tree);
     PrintPreorder(tree);
     return 0;

}
