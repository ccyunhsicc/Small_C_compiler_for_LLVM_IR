; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
declare dso_local i32 @printf(i8*, ...) #1

@.str.0 = private unnamed_addr constant [47 x i8] c"--- Test Case 1: Arithmetic and Simple If ---\0A\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"a + b = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"a - b = %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"a * b = %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"a / b = %d\0A\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"a %% b = %d\0A\00", align 1
@.str.6 = private unnamed_addr constant [23 x i8] c"a + 2 * (b - 10) = %d\0A\00", align 1
@.str.7 = private unnamed_addr constant [29 x i8] c"Result is greater than 120.\0A\00", align 1
@.str.8 = private unnamed_addr constant [18 x i8] c"a - (b * 2) = %d\0A\00", align 1
@.str.9 = private unnamed_addr constant [25 x i8] c"Result is less than 60.\0A\00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c"a&b=%d\0A\00", align 1
@.str.11 = private unnamed_addr constant [8 x i8] c"a|b=%d\0A\00", align 1
@.str.12 = private unnamed_addr constant [8 x i8] c"a^b=%d\0A\00", align 1
@.str.13 = private unnamed_addr constant [9 x i8] c"a>>2=%d\0A\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"a<<2=%d\0A\00", align 1
@.str.15 = private unnamed_addr constant [25 x i8] c"--- Test Case 1 End ---\0A\00", align 1

define dso_local i32 @main() {
    %t0 = alloca i32, align 4
    store i32 100, i32* %t0, align 4
    %t1 = alloca i32, align 4
    store i32 25, i32* %t1, align 4
    %t2 = alloca i32, align 4
    %t3 = alloca i32, align 4
    %t4 = getelementptr inbounds [47 x i8], [47 x i8]* @.str.0, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t4)
    %t5 = load i32, i32* %t0, align 4
    %t6 = load i32, i32* %t1, align 4
    %t7 = add i32 %t5, %t6
    store i32 %t7, i32* %t2, align 4
    %t8 = load i32, i32* %t2, align 4
    %t9 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.1, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t9, i32 %t8)
    %t10 = load i32, i32* %t0, align 4
    %t11 = load i32, i32* %t1, align 4
    %t12 = sub i32 %t10, %t11
    store i32 %t12, i32* %t2, align 4
    %t13 = load i32, i32* %t2, align 4
    %t14 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.2, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t14, i32 %t13)
    %t15 = load i32, i32* %t0, align 4
    %t16 = load i32, i32* %t1, align 4
    %t17 = mul i32 %t15, %t16
    store i32 %t17, i32* %t2, align 4
    %t18 = load i32, i32* %t2, align 4
    %t19 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.3, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t19, i32 %t18)
    %t20 = load i32, i32* %t0, align 4
    %t21 = load i32, i32* %t1, align 4
    %t22 = sdiv i32 %t20, %t21
    store i32 %t22, i32* %t2, align 4
    %t23 = load i32, i32* %t2, align 4
    %t24 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.4, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t24, i32 %t23)
    %t25 = load i32, i32* %t0, align 4
    %t26 = load i32, i32* %t1, align 4
    %t27 = srem i32 %t25, %t26
    store i32 %t27, i32* %t2, align 4
    %t28 = load i32, i32* %t2, align 4
    %t29 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.5, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t29, i32 %t28)
    %t30 = load i32, i32* %t0, align 4
    %t31 = load i32, i32* %t1, align 4
    %t32 = sub i32 %t31, 10
    %t33 = mul i32 2, %t32
    %t34 = add i32 %t30, %t33
    store i32 %t34, i32* %t3, align 4
    %t35 = load i32, i32* %t3, align 4
    %t36 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.6, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t36, i32 %t35)
    %t37 = load i32, i32* %t3, align 4
    %t38 = icmp sgt i32 %t37, 120
    br i1 %t38, label %Ltrue0, label %Lfalse1
    Ltrue0:
    %t39 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.7, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t39)
    br label %Lend2
    Lfalse1:
    br label %Lend2
    Lend2:
    %t40 = load i32, i32* %t0, align 4
    %t41 = load i32, i32* %t1, align 4
    %t42 = mul i32 %t41, 2
    %t43 = sub i32 %t40, %t42
    store i32 %t43, i32* %t3, align 4
    %t44 = load i32, i32* %t3, align 4
    %t45 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.8, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t45, i32 %t44)
    %t46 = load i32, i32* %t3, align 4
    %t47 = icmp slt i32 %t46, 60
    br i1 %t47, label %Ltrue3, label %Lfalse4
    Ltrue3:
    %t48 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.9, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t48)
    br label %Lend5
    Lfalse4:
    br label %Lend5
    Lend5:
    %t49 = load i32, i32* %t0, align 4
    %t50 = load i32, i32* %t1, align 4
    %t51 = and i32 %t49, %t50
    store i32 %t51, i32* %t2, align 4
    %t52 = load i32, i32* %t2, align 4
    %t53 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.10, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t53, i32 %t52)
    %t54 = load i32, i32* %t0, align 4
    %t55 = load i32, i32* %t1, align 4
    %t56 = or i32 %t54, %t55
    store i32 %t56, i32* %t2, align 4
    %t57 = load i32, i32* %t2, align 4
    %t58 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.11, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t58, i32 %t57)
    %t59 = load i32, i32* %t0, align 4
    %t60 = load i32, i32* %t1, align 4
    %t61 = xor i32 %t59, %t60
    store i32 %t61, i32* %t2, align 4
    %t62 = load i32, i32* %t2, align 4
    %t63 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.12, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t63, i32 %t62)
    %t64 = load i32, i32* %t0, align 4
    %t65 = ashr i32 %t64, 2
    store i32 %t65, i32* %t2, align 4
    %t66 = load i32, i32* %t2, align 4
    %t67 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.13, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t67, i32 %t66)
    %t68 = load i32, i32* %t0, align 4
    %t69 = shl i32 %t68, 2
    store i32 %t69, i32* %t2, align 4
    %t70 = load i32, i32* %t2, align 4
    %t71 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.14, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t71, i32 %t70)
    %t72 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.15, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t72)
    ret i32 0
    ret i32 0
}
