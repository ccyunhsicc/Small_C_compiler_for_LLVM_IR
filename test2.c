int main() {
    int x = 50;
    int y = 50;
    int z = 70;

    printf("--- Test Case 2: Comparisons and If-Else ---\n");

    // Test >
    if (x > y) { // False
        printf("x > y is true (should not print).\n");
    } else {
        printf("x > y is false.\n"); // Prints
    }

    // Test >=
    if (x >= y) { // True
        printf("x >= y is true.\n"); // Prints
    } else {
        printf("x >= y is false (should not print).\n");
    }

    // Test <
    if (x < z) { // True
        printf("x < z is true.\n"); // Prints
    } else {
        printf("x < z is false (should not print).\n");
    }

    // Test <=
    if (x <= z) { // True
        printf("x <= z is true.\n"); // Prints
    } else {
        printf("x <= z is false (should not print).\n");
    }

    // Test ==
    if (x == y) { // True
        printf("x == y is true.\n"); // Prints
    } else {
        printf("x == y is false (should not print).\n");
    }

    // Test !=
    if (x != z) { // True
        printf("x != z is true.\n"); // Prints
    } else {
        printf("x != z is false (should not print).\n");
    }

    int val1 = 15;
    int val2 = 30;

    if (val1 * 2 == val2) { // 15 * 2 == 30 -> True
        printf("val1 doubled equals val2.\n");
    } else {
        printf("val1 doubled does not equal val2.\n");
    }

    if (val1 + val2 != 40) { // 15 + 30 = 45; 45 != 40 -> True
        printf("val1 + val2 is not 40.\n");
    } else {
        printf("val1 + val2 is 40.\n");
    }

    printf("--- Test Case 2 End ---\n");
    return 0;
}
