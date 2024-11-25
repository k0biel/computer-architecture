#include <stdio.h>

void szybki_max(short int t_1[], short int t_2[], short int t_wynik[], int n);

int main()
{
    short int val1[16] = { 1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6, 7, -7, -8, 8 };

    short int val2[16] = { -3, -2, -1, 0, 1, 2, 3, 4, 256, -256, 257, -257, 258, -258, 0, 0 };

    short int wynik[16];

    szybki_max(val1, val2, wynik, 16); // -> wynik = {1, -1, 2, 0, 3, 2, 4, 4, 256, -5, 257, -6, 258, -7, 0, 8}
    for (int i = 0; i < 16; i++) {
        printf("%hd ", wynik[i]);
    }
 
    return 0;
}