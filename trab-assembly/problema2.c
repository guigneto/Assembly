#include <stdio.h>

int main(void) {
    int num, count = 0;
    int divisores[100]; 

    printf("Digite um numero: ");
    scanf("%d", &num);

    for (int i=2;i<=num/2;i++) {
        if (num % i == 0) {
            divisores[count++] = i;
        }
    }

    if (count == 0) { 
        printf("%d eh primo\n", num);
    } else {
        printf("%d nao eh primo e tem como divisores ", num);
        for (int i=0;i<count;i++) { 
            printf("%d ", divisores[i]);
        }
        printf("\n");
    }

    return 0;
}