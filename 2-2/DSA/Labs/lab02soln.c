#include<stdio.h>
#include<ctype.h>
#include<string.h>
#include<stdlib.h>
#define MAX 50

typedef struct stack
	{
    int data[MAX];
    int top;
	}stack;

struct node
	{
  	char info[30];
  	struct node *next;
	};

struct node * getnode()
	{
	struct node *p;
	p=(struct node*)malloc(sizeof(struct node));
	return p;
	}
	
int precedence(char);
void init(stack *);
int empty(stack *);
int full(stack *);
int pop(stack *);
void push(stack *,int);
int top(stack *);   //value of the top element
void infix_to_postfix(char infix[],char postfix[]);


int main()
{
    char infix[100],postfix[100];
	scanf("%s",infix);
    infix_to_postfix(infix,postfix);
    printf("%s\n",postfix);

struct node *head2;
head2=NULL;
int k,b=0,count=0;
for(k=0;k<strlen(postfix);k++)
{

   if(!(postfix[k]=='$' || postfix[k]=='/' || postfix[k]=='*' || postfix[k]=='-' || postfix[k]=='+'))
   {
            struct node *h;
            h=getnode();
          	char ch[2];
            ch[0]=postfix[k];
            ch[1]='\0';
            strcpy(h->info,ch);
            h->next=head2;
            head2=h;

   }
   else
   {

       if(postfix[k]=='+')
       {
           struct node *s;
           s=head2->next;
		  printf("LD %s\n",s->info);
           printf("AD %s\n",head2->info);
           head2=head2->next;
           count++;
           char cated[7];
           sprintf(cated,"%s%d","TEMP",count);
           cated[6]='\0';
           strcpy(head2->info,cated);
           printf("ST %s\n",head2->info);

       }
       else if(postfix[k]=='-')
       {
           struct node *s;
           s=head2->next;
           printf("LD %s\n",s->info);
           printf("SB %s\n",head2->info);
           head2=head2->next;
           count++;
           char cated[7];
           sprintf(cated,"%s%d","TEMP",count);
           cated[6]='\0';
           strcpy(head2->info,cated);
           printf("ST %s\n",head2->info);
       }
       else if(postfix[k]=='*')
       {
           struct node *s;
           s=head2->next;
           printf("LD %s\n",s->info);
           printf("ML %s\n",head2->info);
           head2=head2->next;
           count++;
           char cated[7];
           sprintf(cated,"%s%d","TEMP",count);
           cated[6]='\0';
           strcpy(head2->info,cated);
           printf("ST %s\n",head2->info);
       }
       else if(postfix[k]=='/')
       {
           struct node *s;
           s=head2->next;
           printf("LD %s\n",s->info);
           printf("DV %s\n",head2->info);
           head2=head2->next;
           count++;
           char cated[7];
           sprintf(cated,"%s%d","TEMP",count);
           cated[6]='\0';
           strcpy(head2->info,cated);
		  printf("ST %s\n",head2->info);
       }
     }
   }
   return 0;
}

void infix_to_postfix(char infix[],char postfix[])
{
    stack s;
    char x,token;
    int i,j;    //i-index of infix,j-index of postfix
    init(&s);
    j=0;

    for(i=0;infix[i]!='\0';i++)
    {
        token=infix[i];
        if(isalnum(token))
            postfix[j++]=token;
        else
            if(token=='(')
               push(&s,'(');
        else
            if(token==')')
                while((x=pop(&s))!='(')
                      postfix[j++]=x;
                else
                {
                    while(precedence(token)<=precedence(top(&s))&&!empty(&s))
                    {
                        x=pop(&s);
                        postfix[j++]=x;
                    }
                    push(&s,token);
                }
    }

    while(!empty(&s))
    {
        x=pop(&s);
        postfix[j++]=x;
    }

    postfix[j]='\0';
}

int precedence(char x)
{
    if(x=='(')
        return(0);
    if(x=='+'||x=='-')
        return(1);
    if(x=='*'||x=='/'||x=='%')
        return(2);

    return(3);
}

void init(stack *s)
{
    s->top=-1;
}

int empty(stack *s)
{
    if(s->top==-1)
        return(1);

    return(0);
}

int full(stack *s)
{
    if(s->top==MAX-1)
        return(1);

    return(0);
}

void push(stack *s,int x)
{
    s->top=s->top+1;
    s->data[s->top]=x;
}

int pop(stack *s)
{
    int x;
    x=s->data[s->top];
    s->top=s->top-1;
    return(x);
}

int top(stack *p)
{
    return (p->data[p->top]);
}
