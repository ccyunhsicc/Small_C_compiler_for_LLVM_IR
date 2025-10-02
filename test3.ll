; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
declare dso_local i32 @printf(i8*, ...) #1

@.str.0 = private unnamed_addr constant [37 x i8] c"--- Test Case 3: Mixed Features ---\0A\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"Initial local_b: %d\0A\0A\00", align 1
@.str.2 = private unnamed_addr constant [32 x i8] c"local_b after calculation: %d\0A\0A\00", align 1
@.str.3 = private unnamed_addr constant [41 x i8] c"Condition 1 is true (should not print).\0A\00", align 1
@.str.4 = private unnamed_addr constant [23 x i8] c"Condition 1 is false.\0A\00", align 1
@.str.5 = private unnamed_addr constant [48 x i8] c"local_y - local_x is less than or equal to 10.\0A\00", align 1
@.str.6 = private unnamed_addr constant [39 x i8] c"local_y - local_x is greater than 10.\0A\00", align 1
@.str.7 = private unnamed_addr constant [30 x i8] c"Complex equality holds true.\0A\00", align 1
@.str.8 = private unnamed_addr constant [31 x i8] c"Complex equality holds false.\0A\00", align 1
@.str.9 = private unnamed_addr constant [20 x i8] c"Final local_a: %d\0A\0A\00", align 1
@.str.10 = private unnamed_addr constant [20 x i8] c"Final local_x: %d\0A\0A\00", align 1
@.str.11 = private unnamed_addr constant [25 x i8] c"--- Test Case 3 End ---\0A\00", align 1

define dso_local i32 @main() {
    %t0 = alloca i32, align 4
    store i32 100, i32* %t0, align 4
    %t1 = alloca i32, align 4
    store i32 0, i32* %t1, align 4
    %t2 = alloca i32, align 4
    store i32 5, i32* %t2, align 4
    %t3 = alloca i32, align 4
    store i32 12, i32* %t3, align 4
    %t4 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.0, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t4)
    %t5 = load i32, i32* %t1, align 4
    %t6 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.1, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t6, i32 %t5)
    %t7 = load i32, i32* %t2, align 4
    %t8 = mul i32 %t7, 2
    %t9 = load i32, i32* %t0, align 4
    %t10 = sdiv i32 %t9, 10
    %t11 = add i32 %t8, %t10
    store i32 %t11, i32* %t1, align 4
    %t12 = load i32, i32* %t1, align 4
    %t13 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.2, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t13, i32 %t12)
    %t14 = load i32, i32* %t2, align 4
    %t15 = load i32, i32* %t3, align 4
    %t16 = add i32 %t14, %t15
    %t17 = load i32, i32* %t0, align 4
    %t18 = sdiv i32 %t17, 2
    %t19 = icmp sgt i32 %t16, %t18
    %t20 = load i32, i32* %t1, align 4
    %t21 = icmp ne i32 %t20, 20
    %t22 = or i1 %t19, %t21
    br i1 %t22, label %Ltrue0, label %Lfalse1
    Ltrue0:
    %t23 = getelementptr inbounds [41 x i8], [41 x i8]* @.str.3, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t23)
    br label %Lend2
    Lfalse1:
    %t24 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.4, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t24)
    br label %Lend2
    Lend2:
    %t25 = load i32, i32* %t3, align 4
    %t26 = load i32, i32* %t2, align 4
    %t27 = sub i32 %t25, %t26
    %t28 = icmp sle i32 %t27, 10
    br i1 %t28, label %Ltrue3, label %Lfalse4
    Ltrue3:
    %t29 = getelementptr inbounds [48 x i8], [48 x i8]* @.str.5, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t29)
    br label %Lend5
    Lfalse4:
    %t30 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.6, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t30)
    br label %Lend5
    Lend5:
    %t31 = load i32, i32* %t0, align 4
    %t32 = sdiv i32 %t31, 2
    %t33 = load i32, i32* %t3, align 4
    %t34 = add i32 %t33, 38
    %t35 = icmp eq i32 %t32, %t34
    br i1 %t35, label %Ltrue6, label %Lfalse7
    Ltrue6:
    %t36 = getelementptr inbounds [30 x i8], [30 x i8]* @.str.7, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t36)
    br label %Lend8
    Lfalse7:
    %t37 = getelementptr inbounds [31 x i8], [31 x i8]* @.str.8, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t37)
    br label %Lend8
    Lend8:
    %t38 = load i32, i32* %t0, align 4
    %t39 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.9, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t39, i32 %t38)
    %t40 = load i32, i32* %t2, align 4
    %t41 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.10, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t41, i32 %t40)
    %t42 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.11, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t42)
    ret i32 0
    ret i32 0
}
