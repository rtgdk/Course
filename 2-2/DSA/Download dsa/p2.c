#include<stdio.h>
#include<stdlib.h>
#include<string.h>
typedef struct Student{
	char name[9];
	long int id;
}Student;
typedef struct node{
	Student *st;
	struct node *next;
}node;
typedef struct head{
	node *first;	
}head;
typedef struct Hashtable{
	int elementCount;
	float loadFactor;
	int insertionTime;
	int queryingTime;
	int length;
	head *ha;
}Hashtable;
int insert(head *h, Student *s){
	node* n=(node*)malloc(sizeof(node));
	node *t;
	int i=0;
	n->st=s;
	n->next=NULL;
	t=h->first;
	if(t==NULL){
		h->first=n;
		return i;
	}
	while(t->next!=NULL){
		i++;
		t=t->next;
	}
	i++;
	t->next=n;
	return i;
}
int sum(char name[]){
	int s=0,i;
	for(i=0;i<8;i++){
		s+=name[i];
	}
	return s;
}
int Hashfunction(int in,char name[],long int id){
	if(in==1){
		return ((sum(name)%89)%20);
	}
	else if(in==2){
		return ((sum(name)%105943)%20);
	}
	else if(in==3){
		return ((sum(name)%89)%200);
	}
	else if(in==4){
		return ((sum(name)%105943)%200);
	}
	else if(in==5){
		return ((id%89)%20);
	}
	else if(in==6){
		return ((id%105943)%20);
	}
	else if(in==7){
		return ((id%89)%200);
	}
	else if(in==8){
		return ((id%105943)%200);
	}
}
void readRecords(Student* s,int n, Hashtable *h[]){
	int i,j;
	for(i=0;i<n;i++){
		//printf("fin");
		scanf("%s%ld",s[i].name,&s[i].id);
		for(j=0;j<8;j++){
			h[j]->insertionTime+=insert(&((h[j]->ha)[Hashfunction(j+1,s[i].name,s[i].id)]),&s[i]);
		}
		//printf("%s\t%ld\n",s[i].name,s[i].id);
	}
//printf("fllosdok");
		
}
Student *find(Hashtable *h[],int in,char n[],long int id){
	head l=(h[in]->ha)[Hashfunction(in+1,n,id)];
	int i=0;
	node *t=l.first;
	while(t!=NULL){
		i++;
		if(strcmp(((t->st)->name),n)==0 && id==(t->st)->id){
			(h[in]->queryingTime)+=i;
			//printf("finish");
			return t->st;
		}
		t=t->next;
	}
}
void readQueries(int k,Hashtable *h[]){
	int i,j;
	Student *s=(Student *)malloc(sizeof(Student)*k);
	for(i=0;i<k;i++){
		scanf("%s%ld",s[i].name,&s[i].id);
		for(int j=0;j<8;j++){
			find(h,j,s[i].name,s[i].id);
		}
	}
}
void findInsertionComplexity(Hashtable *h[]){
		for(int j=0;j<8;j++){
			printf("%d,%d\t",j+1,h[j]->insertionTime);
		}	
}
void findQueryComplexity(Hashtable *h[]){
		for(int j=0;j<8;j++){
			printf("%d,%d\t",j+1,h[j]->queryingTime);
		}
}			

int main(){
	Student* records;
	Hashtable* h[8];
	int i,n,j;
	for(i=0;i<8;i++){
		h[i]=(Hashtable *)malloc(sizeof(Hashtable));	
		if((i>=0 && i<2)|| (i>=4 &&i<6)){
			h[i]->length=20;
			h[i]->insertionTime=0;
			h[i]->queryingTime=0;
			h[i]->ha=(head*)malloc(sizeof(head)*(h[i]->length));
			for(j=0;j<(h[i]->length);j++){
				(h[i]->ha)[j].first=NULL;
			}
		}
		else{
			h[i]->length=200;
			h[i]->insertionTime=0;
			h[i]->queryingTime=0;
			h[i]->ha=(head*)malloc(sizeof(head)*(h[i]->length));
			for(j=0;j<(h[i]->length);j++){
				(h[i]->ha)[j].first=NULL;
			}
		}
	}
	scanf("%d",&i);
	while(i!=-1){
		if(i==1){
//printf("fin");
		
			scanf("%d",&n);
			records=(Student*)malloc(sizeof(Student)*n);		
			readRecords(records,n,h);
			//printf("finisj");
			
		}
		if(i==2){
//printf("fin");
			int k;
			scanf("%d",&k);
			readQueries(k,h);
//printf("fin");	
		}
		if(i==3){
			findInsertionComplexity(h);
		}
		if(i==4){
			findQueryComplexity(h);
		}
		scanf("%d",&i);
	}
}
