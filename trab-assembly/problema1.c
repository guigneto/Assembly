#include <stdio.h>

int main(void){
    
    int op, num1,num2;

    printf("1-Adicao 2-Subtracao 3-Multiplicacao 4-Divisao\n");
    
    printf("Digite uma operacao: ");
    scanf("%d",&op);

    printf("Digite o primeiro numero: ");
    scanf("%d",&num1);
    printf("Digite o segundo numero: ");
    scanf("%d",&num2);

    if(op == 1) printf("Resultado = %d",num1+num2);
    if(op == 2) printf("Resultado = %d",num1-num2);
    if(op == 3) printf("Resultado = %d",num1*num2);
    if(op == 4) printf("Resultado = %d",num1/num2);

    return 0;
}