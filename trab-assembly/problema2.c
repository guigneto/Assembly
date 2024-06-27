#include <stdio.h>

int main(void) {
    int num, count = 0;

    printf("Digite um numero: ");
    scanf("%d", &num);

    for (int i=2;i<=num/2;i++) {
        if (num % i == 0) {
            count++;
        }
    }

    if (count == 0) { 
        printf("Esse numero e primo.\n",);
    } else {
        printf("Esse numero nao e primo.\nSeus divisores sao:  ",);
        for (int i=2;i<=num/2;i++) { 
            if(num%i==0){
                printf("%d ", i);
            }
        }
        printf("\n");
    }

    return 0;
}