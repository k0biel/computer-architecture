#include <stdio.h>

extern unsigned int fibonacci(unsigned char k);

int main() {
    int a; 

    a = fibonacci(7);    
    printf("fibonacci(7) = %d\n", a);

    a = fibonacci(8);    
    printf("fibonacci(8) = %d\n", a);

    a = fibonacci(48);   
    printf("fibonacci(48) = %d\n", a);

    a = fibonacci(0);    
    printf("fibonacci(0) = %d\n", a);

    return 0;
}

