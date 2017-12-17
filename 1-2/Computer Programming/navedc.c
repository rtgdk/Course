#include <stdio.h>
void main()
{
 int a[3][3],b,i,j,m,n;
 int determinant=0;
 printf("Enter your choice:\n");
 printf("Enter 1 to calculate det. of 2x2 Matrix\n");
 printf("Enter 2 to calculate det. of 3x3 Matrix\n");
 scanf("%d",&b);
 if(b==1)
 {
  printf("Enter the elements:\n");
  for(i=0;i<2;i++)
  {
   for(j=0;j<2;j++)
   {
    scanf("%d",&a[i][j]);
   }
  }
  printf("The entered matrix is:\n");
  for(i=0;i<2;i++)
  {
   for(j=0;j<2;j++)
   {
    printf("%d\t",a[i][j]);
   }
  }  
  printf("\n");
  determinant= a[0][0]*a[1][1] - a[1][0]*a[0][1];
  printf("Determinant is %d",determinant);
 }
 else if(b==2)
 {
  printf("Enter the elements:\n");
  for(i=0;i<3;i++)
  {
   for(j=0;j<3;j++)
   { 
    scanf("%d",&a[i][j]);
   }
  }
  printf("The entered matrix is:\n");
  for(i=0;i<3;i++)
  {
   for(j=0;j<3;j++)
   {
    printf("%d\t",a[i][j]);
   }
   printf("\n");
  }
  for(i=0;i<3;i++)
  {
   determinant=determinant+(a[0][i]*(a[1][(i+1)%3]
   *a[2][(i+2)%3] -  a[1][(i+2)%3]*a[2][(i+1)%3]));
  }
  printf("Determinant is %d",determinant);
 }
}
