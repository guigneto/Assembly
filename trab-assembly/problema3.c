#include <stdio.h>

int calculaPA(int a1,int an,int n){
    return ((a1+an)*n)/2;
}

int main(void){

    int a1, an, n;

    printf("Digite o primeiro termo: ");
    scanf("%d",&a1);

    printf("Digite o ultimo termo: ");
    scanf("%d",&an);

    printf("Digite o numero de termos: ");
    scanf("%d",&n);

    printf("Resultado = %d", calculaPA(a1,an,n));

    return 0;
}