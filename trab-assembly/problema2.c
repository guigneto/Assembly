#include <stdio.h>

int main(void) {
    int num, i, count = 0;
    int divisores[50]; 

    printf("Digite um numero: ");
    scanf("%d", &num);

    // Verifica divisores de 2 até num/2
    for (i = 2; i <= num / 2; i++) {
        if (num % i == 0) {
            divisores[count++] = i; // Armazena o divisor e incrementa o contador
        }
    }

    if (count == 0) { // Se count é 0, então num é primo
        printf("Esse numero e primo.\n");
    } else {
        printf("Esse numero nao e primo.\nSeus divisores sao: ");
        for (i = count-1; i > 0; i--) { // Imprime todos os divisores encontrados
            printf("%d ", divisores[i]);
        }
        printf("\n");
    }

    return 0;
}