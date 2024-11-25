#include <stdio.h>

float dylatacja_czasu(unsigned int delta_t_zero, float predkosc);

int main()
{
    float wynik = dylatacja_czasu(10, 10000.0f); // wynik = 10.00000
    printf("%f\n", wynik);

    float wynik1 = dylatacja_czasu(10, 200000000.0f); // wynik = 13.41641
    printf("%f\n", wynik1);

    float wynik2 = dylatacja_czasu(60, 270000000.0f); // wynik = 137.64944
    printf("%f\n", wynik2);

    return 0;
}
