#include <stdio.h>
int main(int argc,char *argv[]){
	char *start = argv[0];
	printf("%.-3s\t",start);
	int i;
	for(i=1;i<argc;i++){
		printf("%s\t",argv[i]);
	}
}
