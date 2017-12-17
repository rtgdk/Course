#include <stdio.h>
#include <stdlib.h>
#include<string.h>
char words[10000][50];
int loc[10000];
int max=0;
void countsort(int array[][max],int nmwrds)
{  int i,j,k,w,t;
int sort[nmwrds][max];
int loc2[nmwrds];

for(i=max-1;i>=0;i--)
{    for(k=0;k<nmwrds;k++)
    loc2[k]=loc[k];
    int c[27];
    for(j=0;j<27;j++)
        c[j]=0;
    for(j=0;j<nmwrds;j++)
        c[array[j][i]]=c[array[j][i]]+1;
    for(j=1;j<=26;j++)
        c[j]=c[j]+c[j-1];
    for(j=nmwrds-1;j>=0;j--)
    {
     //   sort[c[array[j][i]]-1][i]=array[j][i];
           for(k=0;k<max;k++)
           {
               sort[c[array[j][i]]-1][k]=array[j][k];
           }
        loc[c[array[j][i]]-1]=loc2[j];
        c[array[j][i]]=c[array[j][i]]-1;
    }
        for(t=0;t<nmwrds;t++)
{
    for(w=0;w<max;w++)
        array[t][w]=sort[t][w];
   }
//printf("hello");
    }

 int dummy[max],ln;
for(k=0;k<max;k++)
    dummy[k]=0;
    int flag;
for(i=0;i<nmwrds;i++)
{  flag=0;
    for(j=0;j<max;j++)
    {
       if(sort[i][j]!=dummy[j])
       {
           flag=1;
       }
    dummy[j]=sort[i][j];

    }
    if(flag==1)
    {if(i!=0)
    printf("\n");
        for(j=0;j<max;j++)
            if(sort[i][j]!=0)
            printf("%c",(char)(sort[i][j]+96));
    printf(" %d",loc[i]);
    ln =loc[i];
    }else
    {
    if(loc[i]!=ln)
    {
    printf(", %d",loc[i]);
    ln=loc[i];
    }
    }
}
}
void radix(int nmwrds)
{
int array[nmwrds][max],i,j;
for(i=0;i<nmwrds;i++)
{
    for(j=0;j<max;j++)
    array[i][j]=0;
}
for(i=0;i<nmwrds;i++)
{ //printf("%s ",words[i]);
    int l=strlen(words[i]);
    for(j=0;j<l;j++)
    array[i][j]=(int)(words[i][j])-96;

}
/*for(i=0;i<nmwrds;i++)
{
    for(j=0;j<max;j++)
    printf("%d ",array[i][j]);
    printf("%d",loc[i]);
    printf("\n");
}*/
countsort(array,nmwrds);
}
int main()
{
FILE * fp;
fp =fopen("input.txt","r");
//fprintf(fp,"sasadasd");
//char ch;


int nmwrds=0;
int i,sum=0;
char c,ch[54];
int ln;
c=fscanf(fp,"%d",&ln);
//printf("%d\n",ln);
c=fgetc(fp);
c=fscanf(fp,"%s",ch);
//printf("%s ",ch);
while(1)
{   if(c==EOF) break;
int l=strlen(ch);
int k=l+1;
    if(ch[l-1]=='.' && !(ch[l-2]=='0' || ch[l-2]=='1' || ch[l-2]=='2'|| ch[l-2]=='3'|| ch[l-2]=='4'|| ch[l-2]=='5'|| ch[l-2]=='6'|| ch[l-2]=='7'|| ch[l-2]=='8'|| ch[l-2]=='9'))
    { for(i=0;i<(strlen(ch)-1);i++)
      words[nmwrds][i]=tolower(ch[i]);
      words[nmwrds][i]='\0';
      loc[nmwrds]=ln;

      if(max<strlen(words[nmwrds]))
        max=strlen(words[nmwrds]);
        nmwrds++;
    }
    else if(!(ch[strlen(ch)-1]=='.'))
    { for(i=0;i<(strlen(ch));i++)
      words[nmwrds][i]=tolower(ch[i]);
     words[nmwrds][i]='\0';
      loc[nmwrds]=ln;

      if(max<strlen(words[nmwrds]))
        max=strlen(words[nmwrds]);
        nmwrds++;
    }
   if(isdigit(words[nmwrds-1][strlen(words[nmwrds-1])-1]))
    {
    l=strlen(words[nmwrds-1]);
    //k=l+1;
   ln++;
        nmwrds--;
    }
   c=fscanf(fp,"%s",ch);

}

  //for(i=0;i<nmwrds;i++)
    //printf("\n%s %d",words[i],loc[i]);
//fclose(fp);

//printf(" %d ",max);
radix(nmwrds);
return 0;
 }

