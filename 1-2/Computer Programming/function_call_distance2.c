#include <stdio.h>
#include <math.h>
double square(double a,double b);
double sqrt2(double a);
int main()
{
double a,b,c,d,e,f;
scanf("%lf",&a);
scanf("%lf",&b);
scanf("%lf",&c);
scanf("%lf",&d);
e=square(a,b)+square(c,d);
f=sqrt2(e);
printf("%lf",f);
}
double square(double a,double b)
{
double d;
d=(a-b)*(a-b);
return (d);
}
double sqrt2(double a)
{
double b;
b=pow(a,0.5);
return (b);
}
