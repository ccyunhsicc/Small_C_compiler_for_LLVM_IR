int main() {
    int local_a = 100;
    int local_b = 0; // Explicitly initialized to avoid uninitialized read
    int local_x = 5;
    int local_y = 12;

    printf("--- Test Case 3: Mixed Features ---\n");

    // Initial local_b value
    printf("Initial local_b: %d\n\n", local_b); // Expected: 0

    // Arithmetic with local variables
    local_b = local_x * 2 + local_a / 10; // local_b = 5 * 2 + 100 / 10 = 10 + 10 = 20
    printf("local_b after calculation: %d\n\n", local_b); // Expected: 20

    // Complex comparison and if-then-else
    // (local_x + local_y) > (local_a / 2) || (local_b != 20)
    // (5 + 12) > (100 / 2) || (20 != 20)
    // 17 > 50 (False) || False -> False
    if ((local_x + local_y) > (local_a / 2) || (local_b != 20)) {
        printf("Condition 1 is true (should not print).\n");
    } else {
        printf("Condition 1 is false.\n"); // Prints
    }

    if ((local_y - local_x) <= 10) { // If boolean is represented as 1/0
        printf("local_y - local_x is less than or equal to 10.\n"); // Prints
    } else {
        printf("local_y - local_x is greater than 10.\n");
    }

    // Another if-else with arithmetic
    // local_a / 2 == local_y + 38
    // 100 / 2 == 12 + 38 -> 50 == 50 (True)
    if (local_a / 2 == local_y + 38) {
        printf("Complex equality holds true.\n"); // Prints
    } else {
        printf("Complex equality holds false.\n");
    }

    printf("Final local_a: %d\n\n", local_a); // Expected: 100
    printf("Final local_x: %d\n\n", local_x); // Expected: 5

    printf("--- Test Case 3 End ---\n");
    return 0;
}
