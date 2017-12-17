#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node
{
    int i;
    int r;
    int c;
    int p;
    struct node *lchild;
    struct node *rchild;
};

typedef struct node *NODEPTR;

NODEPTR Insert(NODEPTR T,NODEPTR n)
{
//printf("Insaert executed\n");
        if(T==NULL)
        {
                NODEPTR temp;
                temp = (NODEPTR)malloc(sizeof(struct node));
                temp -> p = n->p;
                temp -> i = n->i;
                temp -> r = n->r;
                temp -> c = n->c;
                temp -> lchild = temp -> rchild = NULL;
                return temp;
        }
        if(n->p >(T->p))
        {
        //printf("Right Insaert executed\n");
             T->rchild = Insert(T->rchild,n);
        }
        else if(n->p < (T->p))
        {
        //printf("Left Insaert executed\n");
             T->lchild = Insert(T->lchild,n);
        }
        return T;
}

NODEPTR FindMax(NODEPTR x)
{
//printf("FindMax executed\n");
//printf("findmax parameter=%d%d%d%d\n",x->i,x->r,x->c,x->p);
        if(x->rchild)
            {FindMax(x->rchild);
           // printf("FindMax_IF executed\n");}
        else
        {//printf("max element=%d%d%d%d\n",x->i,x->r,x->c,x->p);
            return x;}
}

NODEPTR Delete(NODEPTR T)
{
//printf("Delete executed\n");
        NODEPTR temp,temp2;
        temp = FindMax(T);
        temp2 =temp;
       // printf("FindMax returned\n");
       if(temp == NULL){return NULL;};
        if(temp->lchild == NULL)
        {
              temp = temp->rchild;
        }
        temp = temp->lchild;
        return temp2;
}

int main()
{
     int t=0,arr[1000][4]={0},a=0,b=0,e,f,g,h,x,y,sum=0;
     //printf("\n %d",arr[89][0]);
     NODEPTR tree= NULL;
     NODEPTR z,dum;
    // FILE *fp;
     //fp=fopen("data.txt","r");
     while(fscanf(stdin,"%d %d %d %d",&e,&f,&g,&h)!=EOF)
     {
         arr[a][0] = e;
         arr[a][1] = f;
         arr[a][2] = g;
         arr[a][3] = h;
       /*printf("i=%d\n",arr[a][0]);
         printf("r=%d\n",arr[a][1]);
         printf("c=%d\n",arr[a][2]);
         printf("p=%d\n",arr[a][3]);*/
         a++;
      }
      a=0;b=0;
      for(t=0;arr[a][0] != 0 || sum != 0 ;t++)
      {
          if(arr[a][1]==t)
          {
              for(;arr[a][1]==t;a++)
              {
              NODEPTR n;
                  n = (NODEPTR)malloc(sizeof(struct node));
          n->i = arr[a][0];
          n->r = arr[a][1];
          n->c = arr[a][2];
          n->p = arr[a][3];
              n->lchild = NULL;
              n->rchild = NULL;
                 tree=Insert(tree,n);
                 sum =sum + (n->c);
                 //printf("sum=%d\n",sum);
              }
          }
       
       
       if(tree==NULL)
       {printf("output=0\n");}
       else
       {z=Delete(tree);
       sum =sum - (z->c);
       //printf("sum after del=%d\n",sum);
       //printf("computation before sub=%d\n",z->c);
       (z->c) = (z->c) -1;
       //printf("computation=%d\n",z->c);
       printf("output=%d\n",z->i);
       if((z->c) !=0)
       {
       //printf("last if loop\n");
       tree=Insert(tree,z);
       sum =sum + (z->c);
       //printf("sum=%d\n",sum);}
          };
      }
      









   
}