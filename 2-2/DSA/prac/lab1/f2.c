#include <stdio.h>
int main(){
	int num;
	FILE *f = fopen("test.txt","r+");
	if (f==NULL) {
		printf("Error!");
		exit(1);
	}
	fscanf(f,"%d",&num);
	
	printf("Value %d",num);
	fclose(f);
	
	return 0;

}

