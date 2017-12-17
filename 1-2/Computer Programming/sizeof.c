#include <stdio.h>

int main()
{
int a,ab[2],**ac,*ad[2],(*ae)[2];
char b,ba[2],*bb,*bc[2],(*bd)[2];
printf("%u %u %u %u %u %u %u %u %u",sizeof(a),sizeof(ab),sizeof(ac),sizeof(ad),sizeof(ae),sizeof(b),sizeof(ba),sizeof(bb),sizeof(bc),sizeof(bd));
}

