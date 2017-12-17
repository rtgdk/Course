#include <stdio.h>

#include <stdlib.h>

#include <string.h>


/*DEFINING QUEUE AND TREE */


typedef struct node n;


struct node {
	
int data;

	n *leftc, *rightc, *parent;

};


typedef struct queue q;


struct queue {

	n *list[1000];

	int front, rear;

};


int Qadd(q *list, n *add) {

	list->list[list->rear++] = add;
	
return 0;

}


n * Qremove(q *list) 
{
	return list->list[list->front++];
}


n * Qseek(q *list) {
	return list->list[list->front];
}


n * Qseekr(q *list) {
	return list->list[(list->rear)-1];
}



int addTreeNode(n **ref, q *list, int data);

int operator_preced(const char c);

int operator_left_assoc(const char c);

int operator_arg_count(const char c);
int pow2(int n);
int convert_to_postfix(const char *input, char *output);
int evalBoolExpr(char * expr);
void preorder(n **node);


/* MAIN*/

int main() {
	char a[5000], b[5000], c[5000];
	scanf("%s",a);

	char uniqueVar[52], tmp;
	int length = strlen(a), n=0, i, j, u=0, isUnique;

	// Checks for the number of Variables
	for(i=0;i<length;i++) {
		if((a[i] >= 'A' && a[i] <= 'Z') || (a[i] <= 'z' && a[i] >= 'a')) {
			tmp = a[i];
			isUnique = 1;
			for(j=0;j<u;j++) {
				if(uniqueVar[j] == tmp) {
					isUnique = 0;
					break;
				}
			}
			if(isUnique == 1) {
				uniqueVar[u++] = tmp;
				n++;
			}
		}
		else if(a[i] == '+')
			a[i] = '|';
		else if(a[i] == '*')
			a[i] = '&';
		else if(a[i] == '-')
			a[i] = '!';
	}

	
	int binarr[26] = {0};

	convert_to_postfix(a,b);

	q list;
	list.front = 0;
	list.rear = 0;

	struct node *root;

	int tmp1, tmp2, k, x ;
	char node_data;
	i=0;j=0;

	for(i=0;i<=n;i++) {
		for(x=0;x<pow2(i);x++) {
			node_data = 0;
			if(i==n) {
				tmp = x;
				j=0;
				for(k=n-1;k>=0;k--) {		
					tmp1 = pow2(k);
					tmp2 = tmp / tmp1;
					if(tmp2 == 1) {
						tmp = tmp - tmp1;
					}
					binarr[j++] = tmp2;
				}

				for(k=0;k<length;k++) {
					if(b[k] >=65 && b[k] <= 90) { 
						c[k] = 48 + binarr[b[k] - 65];
					}
					else if(b[k] >=97 && b[k] <= 122) {
						c[k] = 48 + binarr[b[k] - 97];
					} 
					else 
						c[k] = b[k];
				}

				node_data = 48 + evalBoolExpr(c);
			}
			else if(i % 2 == 0) {
				node_data = '|';
			}
			else if(i % 2 == 1) {
				node_data = '&';
			}
			addTreeNode(&root, &list, node_data);
		}
	}

	struct node *pop;

	while(1) {
		pop = Qremove(&list);
		if(Qseekr(&list) != pop->parent) {
			Qadd(&list, pop->parent);
		}
		if(pop->data == '&' || pop->data == '|') {
			c[0] = pop->leftc->data;
			c[1] = pop->rightc->data;
			c[2] = pop->data;
			c[3] = '\0';
			pop->data = 48 + evalBoolExpr(c);
		}

		if(pop->parent == NULL) 
			break;
	}

	preorder(&root);
	printf("\n");\
	return 0;
}

/* RECURSIVE PREORDER TRAVERSAL */

void preorder(n **node) {
	printf("%c", (*node)->data);
	if((*node)->leftc != NULL)
		preorder(&((*node)->leftc));
	if((*node)->rightc != NULL)
		preorder(&((*node)->rightc));
} 	

/*Functions*/


int addTreeNode(n **ref, q *list, int data) {
	n *new_node = (n *)malloc(1*sizeof(n));
	new_node->data = data;
	new_node->leftc = NULL;
	new_node->rightc = NULL;
	new_node->parent = NULL;

	if(list->front == list->rear) {
		*ref = new_node;
		Qadd(list, new_node);
		return 1;
	}
	else {
		n *parent = Qseek(list);
		if(parent->leftc == NULL) {
			parent->leftc = new_node;
			new_node->parent = parent;
			Qadd(list, new_node);
			return 1;
		}
		else if(parent->rightc == NULL) {
			parent->rightc = new_node;
			new_node->parent = parent;
			Qadd(list, new_node);
			Qremove(list);
			return 1;
		}
	}
	return 0;
}


/* CONVERTING TO POSTFIX */

int operator_preced(const char c) {
	switch(c) {
		case '|':
			return 6;
		case '&':
			return 5;
		case '!':
			return 4;
	}
	return 0;
}

int operator_left_assoc(const char c) {
	switch(c)    {
		case '|': case '&':
			return 1;
		case '!':
			return 0;
	}
	return 0;
}

int operator_arg_count(const char c) {
	switch(c)  {
		case '&': case '|':
			return 2;
		case '!':
			return 1;
	}
	return 0;
}

int pow2(int n) {
	if(n==0){
		return 1;
		}
	return 2 * pow2(n-1);
}



#define is_operator(c)  (c == '!' || c == '&' || c == '|')
#define is_ident(c)     ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))

int convert_to_postfix(const char *input, char *output) {
	const char *strpos = input, *strend = input + strlen(input);
	char c, *outpos = output;

	char stack[32];
	unsigned int sl = 0; 
	char sc; 

	while(strpos < strend)   {
		c = *strpos;
		
		if(c != ' ')    {
			if(is_ident(c))  {
				*outpos = c; ++outpos;
			}
		
			else if(is_operator(c))  {
				while(sl > 0)    {
					sc = stack[sl - 1];
					if(is_operator(sc) &&
						((operator_left_assoc(c) && (operator_preced(c) >= operator_preced(sc))) ||
						   (operator_preced(c) > operator_preced(sc))))   {
						*outpos = sc;
						++outpos;
						sl--;
					}
					else   {
						break;
					}
				}
				stack[sl] = c;
				++sl;
			}
			else if(c == '(')   {
				stack[sl] = c;
				++sl;
			}
			else if(c == ')')    {
				int pe = 0;
				while(sl > 0)     {
					sc = stack[sl - 1];
					if(sc == '(')    {
						pe = 1;
						break;
					}
					else  {
						*outpos = sc;
						++outpos;
						sl--;
					}
				}
				sl--;
				if(sl > 0)   {
					sc = stack[sl - 1];
				}
			}
		}
		++strpos;
	}

	while(sl > 0)  {
		sc = stack[sl - 1];
		*outpos = sc;
		++outpos;
		--sl;
	}
	*outpos = 0; 
	return 1;
}


/* EVALUATING THE BOOLEAN EXPRESSION */

int evalBoolExpr(char * expr)  {
    char output[500] = {0};
    char * operator;
    int tmp;
    char part1[250], part2[250];
    strcpy(output, expr);
 
    while (strlen(output) > 1) {
        operator = &output[0];
        while (!is_operator(*operator) && *operator != '\0')
          operator++;
        if (*operator == '\0') {
          return 0;  // oops - zero operators found
        }
        else if (*operator == '!') {
            tmp = !(*(operator-1) - 48);
            *(operator-1) = '\0';
        }
        else if(*operator == '&') {
            tmp = (*(operator-1) - 48) && (*(operator-2) - 48);
            *(operator-2) = '\0';
        }
        else if (*operator == '|') {
            tmp = (*(operator-1) - 48) || (*(operator-2) - 48);
            *(operator-2) = '\0';
        }
 
        memset(part1, 0, sizeof(part1));
        memset(part2, 0, sizeof(part2));
        strcpy(part1, output);
        strcpy(part2, operator+1);
        memset(output, 0, sizeof(output));
        strcat(output, part1);
        strcat(output, ((tmp==0) ? "0" : "1"));
        strcat(output, part2);
    }
    return *output - 48;
}	






