#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

long power(int n)
{
    long result=1;
    int i;
    for(i=0;i<n;i++)
    {
        result = result*10;
    }

    return result;
}
char* int_char(long long num)
{
    char *c = (char*)malloc(sizeof(char)*1000);
    int count = 0;
    long long cpy = num;
    while(cpy!=0){cpy/=10;count++;}
    c[count] = '\0';
    count--;
    while(count!=-1)
    {
        c[count] = (char)(num%10+'0');
        num/=10;
        count--;
    }
    return c;
}

char* high(char* num)
{
    int i;
    int x = strlen(num);
   // puts(num);
    //printf("x aa raha hai%d",x);
    char *h = (char*)malloc(sizeof(char)*1000);
    for(i=0;i<(x+1)/2;i++)
    {
        h[i] = num[i];
    }
    h[i] = '\0';
    //printf("%d\n",count);

    return h;
}

char* low(char* num)
{
    int i,x = strlen(num);
    char *h = (char*)malloc(sizeof(char)*1000);
    //char *h = (char)malloc(100);
    for(i=0;i<x/2;i++)
    {
        h[i] = num[(x+1)/2+i];
    }
    h[i]='\0';
    //printf("%d\n",count);
   // puts("hhhh");

    return h;
}

struct stack
{
    struct node* element;
    struct stack* ptr;
};
struct stack* top=NULL;

void push(struct node *t){
     if (top == NULL)
    {
        top =(struct stack *)malloc(1*sizeof(struct stack));
        top->ptr = NULL;
        top->element = t;
    }
    else
    {
        struct stack*temp;
        temp =(struct stack *)malloc(1*sizeof(struct stack));
        temp->element=t;
        temp->ptr=top;
        top=temp;
    }
}

struct node* pop()
{
    struct stack* top1;
    top1 = top;

    if (top1 == NULL)
    {
        return top1;
    }
    else{
        if(top1->ptr == NULL)
        {
            top = NULL;
            //return top1->element;
        }
        else{
        top = top1->ptr;
    //free(top);
    //top = top1;
        }
    return top1->element;
}}

struct queue
{
    struct node* tree ;
    struct queue* link;
};
struct queue* front = NULL,*rear = NULL;

void addq(struct node* t)
{
    struct queue *temp;
    temp = (struct queue*)malloc(1*sizeof(struct queue));
    temp->link = NULL;
    temp->tree=t;
    if (rear  ==  NULL)
    {
        front = rear = temp;
    }
    else
    {
        rear->link = temp;
        rear = temp;
    }
}

void delq()
{
    struct queue *temp;



    temp = front;

    if (temp == NULL)
    {
        return;
    }
    else
        if (temp->link != NULL)
        {
            temp = temp->link;
            free(front);
            front = temp;
        }
        else
        {
            free(front);
            front = NULL;
            rear = NULL;
        }
}

struct node
{
    char* a;
    char* b;
    int l;
    char* value;
    struct node *left,*right,*center,*parent;
};

struct node* left_child(struct node* t)
{
    char *h1,*h2,*l1,*l2;
    long long x1,y1,x2,y2;
    h1 = high(t->a);
    x1 = atoi(h1);
    l1 = low(t->a);
    y1 = atoi(l1);
    h2 = high(t->b);
    x2 = atoi(h2);
    l2 = low(t->b);
    y2 = atoi(l2);
    long x3 = x1 + y1;
    long y3 = x2 + y2;
    //printf("\n number %ld  %ld",x3,y3);
    char *one;
    char *two;
    //char *khali = mal
    struct node* temp;
    temp = (struct node*)malloc(1*sizeof(struct node));
    one = int_char((long long)(x3));
    two = int_char((long long)(y3));

    //puts(one);
    //puts(two);
    temp->a = one;
    temp->b = two;
    temp->l = 1;
    temp->left = temp->right = temp->center = NULL;
    temp->parent = t;
   // printf("left");
    //puts(temp->a);
    //puts(temp->b);
    return temp;
}

struct node* center_child(struct node* t)
{
    char *h1,*h2;
    // printf("gaand\n");
    h1 = high(t->a);
    h2 = high(t->b);
    //puts(h1);puts(h2);
    struct node* temp;
    temp = (struct node*)malloc(1*sizeof(struct node));
    temp->a = h1;
    temp->b = h2;
    temp->l = 0;
    temp->left = temp->right = temp->center = NULL;
    temp->parent = t;
    return temp;
}

struct node* right_child(struct node* t)
{
    char *h1,*h2;
    h1 = low(t->a);
    h2 = low(t->b);
    struct node* temp;
    temp = (struct node*)malloc(1*sizeof(struct node));
    temp->a = h1;
    temp->b = h2;
    temp->l = 0;
    temp->left = temp->right = temp->center = NULL;
    temp->parent = t;
    return temp;
}




void create_tree(struct node* temp)
{
    while(front!=NULL)
    {
        temp = front->tree;
        //printf("nxt\n");
        //puts(temp->a);
        //puts(temp->b);

        if(strlen(temp->a) == 1 && strlen(temp->b) == 1)
        {
            delq();
            push(temp);
            //printf("aaa\n");
        }
        else
        {
            temp->center = center_child(temp);
            temp->right = right_child(temp);
            temp->left = left_child(temp);
            addq(temp->left);
            addq(temp->center);
            addq(temp->right);
            delq(temp);
           // printf("xxx");
        }

        //puts(temp->left->a);
       // puts(temp->left->b);
        //puts(temp->center->a);
        //puts(temp->center->b);
        //puts(temp->right->a);
        //puts(temp->right->b);
    }
    //delq();
           // push(temp);
    step_two();
   /* printf("stack\n");
    while(top!=NULL)
    {
        puts(top->element->a);
        puts(top->element->b);
        top=top->ptr;
    }*/
}

void step_two()
{
    //printf("two\n");
    while(top!=NULL)
    {
        struct node* temp;
        temp = (struct node*)malloc(1*sizeof(struct node));
        temp = pop();
        //puts(temp->a);
        //puts(temp->b);
        addq(temp);
    }

    conquer();
}

void conquer()
{
    struct queue* temp;
    temp = front;
    //printf("%s",temp->tree->a);
    while(front!=NULL)
    {
        if(temp->tree->l==1)
        {
            addq(temp->tree->parent);
        }
        if(strlen(temp->tree->a) == 1 && strlen(temp->tree->b) == 1)
        {
            printf("%sX%s=",temp->tree->a,temp->tree->b);
            int x = atoi(temp->tree->a);
            int y = atoi(temp->tree->b);
            temp->tree->value = int_char((long long)x*y);
            printf("%d\n",x*y);
        }
        else
        {

            printf("%sX%s=",temp->tree->a,temp->tree->b);
            /*int a1,a2,a3,b1,b2,b3;
            a1=atoi(temp->tree->left->a);
            a2=atoi(temp->tree->center->a);
            a3=atoi(temp->tree->right->a);
            b1=atoi(temp->tree->left->b);
            b2=atoi(temp->tree->center->b);
            b3=atoi(temp->tree->right->b);
            */
            int x = strlen(temp->tree->a);
            //printf("this %d",atoi(temp->tree->center->value));
            //printf("this %d",atoi(temp->tree->left->value));
            //printf("this %d",atoi(temp->tree->right->value));
            //printf("%d",power(x));
            long z1,z2,z3,z4;
            z1=(long)atoi(temp->tree->center->value);
            //printf("%ld",z1);
            z2=(atoi(temp->tree->left->value)-atoi(temp->tree->center->value)-atoi(temp->tree->right->value));
            z3=atoi(temp->tree->right->value);
            z4 = atoi(temp->tree->left->value);
            //printf("%ld",z2);
            //printf("%ld",z3);
            temp->tree->value=int_char(z1*power(x)+ z2*power(x/2) + z3);
            printf("%ldX%dX%d+",z1,power(x/2),power(x/2));
            printf("(%ld-%ld-%ld)X%d+",z4,z1,z3,power(x/2));
            printf("%ld=",z3);
            printf("%s",(temp->tree->value));
            printf("\n");
        }
        delq();
        temp = front;
    }
}


/*itoa(x3,one,10);
int no_of_digits(int num)
{
    int count = 0;
    while(num!=0)
    {
        num /= 10;
        count++;
    }itoa(x3,one,10);
    return count;
}
*/


int main()
{


    char input[500],num_1[1000],num_2[1000];
    int l,i,j,int_1=0,int_2=0;
    scanf("%s",input);
    l = strlen(input);
    for(i=0;i<l;i++)
    {
        if(input[i] == 'X')
            break;
    }
    for(j=0;j<i;j++)
    {
        num_1[j] = input[j];
        //int_1 += input[j]*pow(10,i-j);
    }
    num_1[j] = '\0';
    for(j=0;j<l-i-1;j++)
    {
        num_2[j] = input[l-i+j];
       // int_2 += input[l-i+j]*pow(10,l-i-1-j);
    }
    num_2[j] = '\0';
    //printf("%s\n",high(num_1));
    //printf("%s\n",low(num_1));
    //puts(high(num_1));

    //printf("print%s",cc);
    //for(j=0;j<i;j++)
    //int_1 = atoi(num_1);
        //printf("%d",int_1);


    //for(j=0;j<l-i-1;j++)
    //int_2 = atoi(num_2);
        //printf("%d",int_2);1
    //int h1 = high(int_1);
    //int l1 = low(int_1);
    //printf("%d\n%d",h1,l1);
    //puts(high(num_1));
    //puts(low(num_1));

    struct node* root;
    root = (struct node*)malloc(1*sizeof(struct node));
    root->a = num_1;
    root->b = num_2;
    root->l = 2;
    root->left=root->right=root->center=root->parent = NULL;
    addq(root);
    create_tree(root);

    return 0;

}
