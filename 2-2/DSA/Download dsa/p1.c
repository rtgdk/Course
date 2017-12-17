#include<stdio.h>
#include<stdlib.h>
typedef struct node{
	int ele;
	struct node* next;
}node;
typedef struct head{
	node *first;
	int size;
}head;
void insert(head* head,int i){
	node *n,*t,*p;
	n=(node*)malloc(sizeof(node));
	n->ele=i;
	t=head->first;
	if(t==NULL || t->ele>=i){
		n->next=head->first;	
		head->first=n;
	}
	else{
		p=t;
		while(t!=NULL){
			//p=t;
			if(t->ele>=i){
				break;			
			}
			p=t;
			t=t->next;
			
		}
		n->next=p->next;
		p->next=n;
	}
}
void readData(int **a,int m){
	int i;	
	for(i=0;i<m;i++){
		scanf("%d%d",&a[i][0],&a[i][1]);
		//printf("%d %d\n",a[i][0],a[i][1]);

	}
}
void print(int **a,int m){
	int i;

	for(i=0;i<m;i++){
		printf("%d %d\n",a[i][0],a[i][1]);
	}
}
void SortSparseLists(int **a,int size,int xLo,int xHi,int yLo,int yHi){
	head *b=(head *)malloc(sizeof(head)*(xHi-xLo+1));
	int i,j;
	for(int j=0;j<(xHi-xLo+1);j++){
		b[j].first=NULL;
	}	
	for(i=0;i<size;i++){
		insert(&b[a[i][0]-xLo],a[i][1]);	
	}
	i=0;
		for(j=0;j<(xHi-xLo+1);j++){
			if(b[j].first==NULL){
				continue;			
			}
			else{
				node *t;
				t=b[j].first;
				while(t!=NULL){
					a[i][0]=xLo+j;
					a[i][1]=t->ele;
					i++;
					t=t->next;
				}					
			}
		}
	print(a,size);
}
void SortDenseLists(int **a,int size,int xLo,int xHi,int yLo,int yHi){
	head **b =(head**)malloc(sizeof(head*)*(xHi-xLo+1));
	int i,j;	
	for(i=0;i<(xHi-xLo+1);i++){
		b[i]=(head*)malloc(sizeof(head)*(yHi-yLo+1));
		for(j=0;j<(yHi-yLo+1);j++){
			b[i][j].first=NULL;			
			b[i][j].size=0;
		} 
	}
	for(int i=0;i<size;i++){
		b[a[i][0]-xLo][a[i][1]-yLo].size++;
	}
	int k=0;
	for(i=0;i<(xHi-xLo+1);i++){
		for(j=0;j<(yHi-yLo+1);j++){
			while(b[i][j].size){
				a[k][0]=i+xLo;
				a[k][1]=j+yLo;
				b[i][j].size--;
				k++;
			}
		}
	}
	print(a,size);
}
int main(){
	int **a;
	int i;
	int size,xLo,xHi,yLo,yHi;
	scanf("%d",&i);
	while(i!=-1){
		if(i==0){
			scanf("%d%d%d%d%d",&size,&xLo,&xHi,&yLo,&yHi);		
			a=(int**)malloc(sizeof(int*)*size);
			for(int j=0;j<size;j++){
				a[j]=(int *)malloc(sizeof(int)*2);
			}
			//printf("read");
			readData(a,size);
			//printf("read");
			//print(a,size);
			//printf("read");

		}
		if(i==1){
			SortSparseLists(a,size,xLo,xHi,yLo,yHi);
		}
		if(i==2){
			SortDenseLists(a,size,xLo,xHi,yLo,yHi);
		}
		scanf("%d",&i);
	}
	return 0;
}
/*
0 20 89 99 85 95
92 92
98 90
93 87
93 89
91 93
93 90
91 85
94 92
93 88
92 93
96 94
94 91
93 86
93 92
90 92
90 86
92 85
97 85
97 88
97 86
*/
