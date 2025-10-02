; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
declare dso_local i32 @printf(i8*, ...) #1

@.str.0 = private unnamed_addr constant [46 x i8] c"--- Test Case 2: Comparisons and If-Else ---\0A\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"x > y is true (should not print).\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"x > y is false.\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"x >= y is true.\0A\00", align 1
@.str.4 = private unnamed_addr constant [37 x i8] c"x >= y is false (should not print).\0A\00", align 1
@.str.5 = private unnamed_addr constant [16 x i8] c"x < z is true.\0A\00", align 1
@.str.6 = private unnamed_addr constant [36 x i8] c"x < z is false (should not print).\0A\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"x <= z is true.\0A\00", align 1
@.str.8 = private unnamed_addr constant [37 x i8] c"x <= z is false (should not print).\0A\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"x == y is true.\0A\00", align 1
@.str.10 = private unnamed_addr constant [37 x i8] c"x == y is false (should not print).\0A\00", align 1
@.str.11 = private unnamed_addr constant [17 x i8] c"x != z is true.\0A\00", align 1
@.str.12 = private unnamed_addr constant [37 x i8] c"x != z is false (should not print).\0A\00", align 1
@.str.13 = private unnamed_addr constant [27 x i8] c"val1 doubled equals val2.\0A\00", align 1
@.str.14 = private unnamed_addr constant [35 x i8] c"val1 doubled does not equal val2.\0A\00", align 1
@.str.15 = private unnamed_addr constant [24 x i8] c"val1 + val2 is not 40.\0A\00", align 1
@.str.16 = private unnamed_addr constant [20 x i8] c"val1 + val2 is 40.\0A\00", align 1
@.str.17 = private unnamed_addr constant [25 x i8] c"--- Test Case 2 End ---\0A\00", align 1

define dso_local i32 @main() {
    %t0 = alloca i32, align 4
    store i32 50, i32* %t0, align 4
    %t1 = alloca i32, align 4
    store i32 50, i32* %t1, align 4
    %t2 = alloca i32, align 4
    store i32 70, i32* %t2, align 4
    %t3 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.0, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t3)
    %t4 = load i32, i32* %t0, align 4
    %t5 = load i32, i32* %t1, align 4
    %t6 = icmp sgt i32 %t4, %t5
    br i1 %t6, label %Ltrue0, label %Lfalse1
    Ltrue0:
    %t7 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.1, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t7)
    br label %Lend2
    Lfalse1:
    %t8 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.2, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t8)
    br label %Lend2
    Lend2:
    %t9 = load i32, i32* %t0, align 4
    %t10 = load i32, i32* %t1, align 4
    %t11 = icmp sge i32 %t9, %t10
    br i1 %t11, label %Ltrue3, label %Lfalse4
    Ltrue3:
    %t12 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.3, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t12)
    br label %Lend5
    Lfalse4:
    %t13 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.4, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t13)
    br label %Lend5
    Lend5:
    %t14 = load i32, i32* %t0, align 4
    %t15 = load i32, i32* %t2, align 4
    %t16 = icmp slt i32 %t14, %t15
    br i1 %t16, label %Ltrue6, label %Lfalse7
    Ltrue6:
    %t17 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.5, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t17)
    br label %Lend8
    Lfalse7:
    %t18 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.6, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t18)
    br label %Lend8
    Lend8:
    %t19 = load i32, i32* %t0, align 4
    %t20 = load i32, i32* %t2, align 4
    %t21 = icmp sle i32 %t19, %t20
    br i1 %t21, label %Ltrue9, label %Lfalse10
    Ltrue9:
    %t22 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.7, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t22)
    br label %Lend11
    Lfalse10:
    %t23 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.8, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t23)
    br label %Lend11
    Lend11:
    %t24 = load i32, i32* %t0, align 4
    %t25 = load i32, i32* %t1, align 4
    %t26 = icmp eq i32 %t24, %t25
    br i1 %t26, label %Ltrue12, label %Lfalse13
    Ltrue12:
    %t27 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.9, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t27)
    br label %Lend14
    Lfalse13:
    %t28 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.10, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t28)
    br label %Lend14
    Lend14:
    %t29 = load i32, i32* %t0, align 4
    %t30 = load i32, i32* %t2, align 4
    %t31 = icmp ne i32 %t29, %t30
    br i1 %t31, label %Ltrue15, label %Lfalse16
    Ltrue15:
    %t32 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.11, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t32)
    br label %Lend17
    Lfalse16:
    %t33 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.12, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t33)
    br label %Lend17
    Lend17:
    %t34 = alloca i32, align 4
    store i32 15, i32* %t34, align 4
    %t35 = alloca i32, align 4
    store i32 30, i32* %t35, align 4
    %t36 = load i32, i32* %t34, align 4
    %t37 = mul i32 %t36, 2
    %t38 = load i32, i32* %t35, align 4
    %t39 = icmp eq i32 %t37, %t38
    br i1 %t39, label %Ltrue18, label %Lfalse19
    Ltrue18:
    %t40 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.13, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t40)
    br label %Lend20
    Lfalse19:
    %t41 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.14, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t41)
    br label %Lend20
    Lend20:
    %t42 = load i32, i32* %t34, align 4
    %t43 = load i32, i32* %t35, align 4
    %t44 = add i32 %t42, %t43
    %t45 = icmp ne i32 %t44, 40
    br i1 %t45, label %Ltrue21, label %Lfalse22
    Ltrue21:
    %t46 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.15, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t46)
    br label %Lend23
    Lfalse22:
    %t47 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.16, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t47)
    br label %Lend23
    Lend23:
    %t48 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.17, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t48)
    ret i32 0
    ret i32 0
}
