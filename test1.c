int main() {
    int a = 100;
    int b = 25;
    int c;
    int result;

    printf("--- Test Case 1: Arithmetic and Simple If ---\n");

    // Arithmetic computations
    c = a + b; // 125
    printf("a + b = %d\n", c);

    c = a - b; // 75
    printf("a - b = %d\n", c);

    c = a * b; // 2500
    printf("a * b = %d\n", c);

    c = a / b; // 4
    printf("a / b = %d\n", c);

    c = a % b; // 0
    printf("a %% b = %d\n", c);

    result = a + 2 * (b - 10); // 100 + 2 * (25 - 10) = 100 + 2 * 15 = 100 + 30 = 130
    printf("a + 2 * (b - 10) = %d\n", result);

    // Simple if-then
    if (result > 120) {
        printf("Result is greater than 120.\n");
    }

    result = a - (b * 2); // 100 - 50 = 50
    printf("a - (b * 2) = %d\n", result);

    if (result < 60) {
        printf("Result is less than 60.\n");
    }
    
    c=a&b;
    printf("a&b=%d\n",c);
    c=a|b;
    printf("a|b=%d\n",c);
    c=a^b;
    printf("a^b=%d\n",c);
    c=a>>2;
    printf("a>>2=%d\n",c);
    c=a<<2;
    printf("a<<2=%d\n",c);

    printf("--- Test Case 1 End ---\n");
    return 0;
}
