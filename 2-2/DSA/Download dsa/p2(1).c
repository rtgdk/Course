#include <stdio.h>
#include <stdlib.h>
struct node{
    int lo;
	int hi;
    struct node *next;
};
struct stack{
    int size;
    struct node *first;
};
void push(struct stack *head,int lo,int hi){
    struct node *n,*p=(struct node *)malloc(sizeof(struct node));
    n=(struct node *)malloc(sizeof(struct node));
    int i;
    //scanf("%d",&i);
    n->lo=lo;
	n->hi=hi;
    n->next=head->first;
    head->first=n;
    head->size++;
}
struct node* top(struct stack *head){
    struct node *p=(struct node *)malloc(sizeof(struct node));
    p=head->first;
    if(p==NULL){
        printf("Empty");
    }
	return p;
}
void pop(struct stack *head){
    struct node *p=(struct node *)malloc(sizeof(struct node));

    p=head->first;
    if(p==NULL){
        printf("Empty");
    }
    else{
        head->first=p->next;
        head->size--;
    }
}

typedef struct {
	char name[21];
	unsigned int marks;
}Student;
void readData(Student st[],int m){
	int i;
	for( i=0;i<m;i++){
		Student s;
		scanf("%s",s.name);
		scanf("%d",&s.marks);
		st[i]=s;
	}
}
int pivot(Student st[],int lo,int hi){
	return hi;
}
void swap(Student st[],int i ,int j){
	Student t=st[i];
	st[i]=st[j];
	st[j]=t;
}
void print(Student st[],int lo,int hi){
	int  i;
	for(i=lo;i<=hi;i++){
		printf("%s %d\n",st[i].name,st[i].marks);
	}
}

int part(Student st[],int lo,int hi,int p){
	swap(st,lo,p);
	int f=lo+1;
	int h=hi;
	while(f<=h){
		while(st[f].marks<=st[lo].marks && f<=hi){
			f++;
		}
		while(st[h].marks>st[lo].marks && h>=lo){
			h--;
		}
		if(f<h){
			swap(st,f,h);
			f++;
			h--;
		}
	}
	swap(st,f-1,lo);
	return f-1;
}
void quicksort(Student st[], int m, int lo, int hi ){
	if(m==3){
		///rintf("sf");
		while(lo<hi){
			int p=part(st,lo,hi,pivot(st,lo,hi));
			//int size1=p-lo;
			//int size2=hi-p;
			if(p-lo<=2){
				if(lo==p || lo==p-1){
					//return ;
				}
				else if(st[lo].marks>st[p-1].marks){
					swap(st,lo,p-1);
				}
				//return ;
			}
			else{
				quicksort(st,m,lo,p-1);
			}
			if(hi-p<=2){
				if(hi==p || hi==p+1){
					return ;
				}
				else if(st[hi].marks<st[p+1].marks){
					swap(st,hi,p+1);
				}
				return ;
			}
			else{
				//quicksort(st,m,p+1,hi);
				lo=p+1;
			}

		}
		return;
	}
	if(lo<hi){
		int p=part(st,lo,hi,pivot(st,lo,hi));
		if(m==1){
			quicksort(st,m,lo,p-1);
			quicksort(st,m,p+1,hi);
		}
		if(m==2){
			if(p-lo<=2){
				if(lo ==p || lo==p-1){
					//return ;
				}
				else if(st[lo].marks>st[p-1].marks){
					swap(st,lo,p-1);
				}
			}
			else{
				quicksort(st,m,lo,p-1);
			}
			if(hi-p<=2){
				if(hi==p || hi==p+1){
					//return ;
				}
				else if(st[hi].marks<st[p+1].marks){
					swap(st,hi,p+1);
				}
				//return;
			}
			else{
				quicksort(st,m,p+1,hi);
			}
		}
	}
}
void qs4(Student st[], int lo, int hi ){
	struct stack *s=(struct stack *)malloc(sizeof(struct stack));
	push(s,lo,hi);
	struct node *e;
	while(top(s)!=NULL){
		e=top(s);
		lo=e->lo;
		hi=e->hi;
		pop(s);
		while(lo<hi){
			int p=part(st,lo,hi,pivot(st,lo,hi));
			//int size1=p-lo;
			//int size2=hi-p;
			if(p-lo<=2){
				if(lo==p || lo==p-1){
					//return ;
				}
				else if(st[lo].marks>st[p-1].marks){
					swap(st,lo,p-1);
				}
				//return ;
			}
			else{
				//quicksort(st,m,lo,p-1);
				push(s,lo,p-1);
			}
			if(hi-p<=2){
				if(hi==p || hi==p+1){
					//return ;
				}
				else if(st[hi].marks<st[p+1].marks){
					swap(st,hi,p+1);
				}
				break ;
			}
			else{
				//quicksort(st,m,p+1,hi);
				lo=p+1;
			}
		}
	}
}
void pa(Student st[], int m, int lo, int hi ){

	if(lo<hi){
		int p=part(st,lo,hi,pivot(st,lo,hi));
        int f=p-lo,s=hi-p;
        if(f>=s && f<m){
            return ;
        }
        if(s>=f && s<m){
            return ;
        }
			pa(st,m,lo,p-1);
			pa(st,m,p+1,hi);
    }
}


int main(){
	int i,size;
	scanf("%d",&i);
	Student *st;
	while(i!=-1){
		if(i==0){
			int m;
			scanf("%d",&m);
			size=m;
			st=(Student *)malloc(m*sizeof(Student));
			readData(st,m);
			//print(st,0,size-1);
		}
		if(i==2){
			int m;
			scanf("%d",&m);
			if(m==4){
				qs4(st,0,size-1);
			}
			else quicksort(st,m,0,size-1);
			print(st,0,size-1);
		}
	scanf("%d",&i);
	}
    return 0;
}
