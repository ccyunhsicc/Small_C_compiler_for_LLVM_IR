; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
declare dso_local i32 @printf(i8*, ...) #1

@.str.0 = private unnamed_addr constant [10 x i8] c"num1: %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"num2: %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"baseline end\0A\00", align 1
@.str.3 = private unnamed_addr constant [24 x i8] c"Logical operation pass\0A\00", align 1
@.str.4 = private unnamed_addr constant [31 x i8] c"Floating point data type pass\0A\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.6 = private unnamed_addr constant [26 x i8] c"Nested if construct pass\0A\00", align 1
@.str.7 = private unnamed_addr constant [38 x i8] c"if %d = 144, For-loop construct pass\0A\00", align 1
@.str.8 = private unnamed_addr constant [40 x i8] c"if %d = 144, while-loop construct pass\0A\00", align 1
@.str.9 = private unnamed_addr constant [48 x i8] c"if %d = 14, Loop construct + if construct pass\0A\00", align 1

define dso_local i32 @main() {
    %t0 = alloca i32, align 4
    %t1 = alloca i32, align 4
    %t2 = sdiv i32 10, 5
    %t3 = add i32 2, %t2
    %t4 = mul i32 1, 5
    %t5 = srem i32 %t4, 7
    %t6 = sub i32 %t3, %t5
    store i32 %t6, i32* %t0, align 4
    %t7 = load i32, i32* %t0, align 4
    %t8 = load i32, i32* %t0, align 4
    %t9 = mul i32 %t8, 2
    %t10 = add i32 %t7, %t9
    %t11 = mul i32 4, 7
    %t12 = load i32, i32* %t0, align 4
    %t13 = mul i32 %t11, %t12
    %t14 = sdiv i32 %t13, 14
    %t15 = sub i32 %t10, %t14
    store i32 %t15, i32* %t1, align 4
    %t16 = load i32, i32* %t0, align 4
    %t17 = load i32, i32* %t1, align 4
    %t18 = icmp eq i32 %t16, %t17
    br i1 %t18, label %Ltrue0, label %Lfalse1
    Ltrue0:
    store i32 5, i32* %t0, align 4
    br label %Lend2
    Lfalse1:
    store i32 10, i32* %t1, align 4
    br label %Lend2
    Lend2:
    %t19 = load i32, i32* %t0, align 4
    %t20 = load i32, i32* %t1, align 4
    %t21 = icmp sle i32 %t19, %t20
    br i1 %t21, label %Ltrue3, label %Lfalse4
    Ltrue3:
    %t22 = load i32, i32* %t1, align 4
    %t23 = load i32, i32* %t0, align 4
    %t24 = sub i32 %t22, %t23
    store i32 %t24, i32* %t0, align 4
    br label %Lend5
    Lfalse4:
    %t25 = load i32, i32* %t0, align 4
    %t26 = load i32, i32* %t1, align 4
    %t27 = sub i32 %t25, %t26
    store i32 %t27, i32* %t1, align 4
    br label %Lend5
    Lend5:
    %t28 = load i32, i32* %t0, align 4
    %t29 = load i32, i32* %t1, align 4
    %t30 = add i32 %t29, 1
    %t31 = icmp sgt i32 %t28, %t30
    br i1 %t31, label %Ltrue6, label %Lfalse7
    Ltrue6:
    %t32 = load i32, i32* %t1, align 4
    store i32 %t32, i32* %t0, align 4
    br label %Lend8
    Lfalse7:
    br label %Lend8
    Lend8:
    %t33 = load i32, i32* %t0, align 4
    %t34 = load i32, i32* %t1, align 4
    %t35 = icmp ne i32 %t33, %t34
    br i1 %t35, label %Ltrue9, label %Lfalse10
    Ltrue9:
    store i32 0, i32* %t1, align 4
    br label %Lend11
    Lfalse10:
    br label %Lend11
    Lend11:
    %t36 = load i32, i32* %t0, align 4
    %t37 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.0, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t37, i32 %t36)
    %t38 = load i32, i32* %t1, align 4
    %t39 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.1, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t39, i32 %t38)
    %t40 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.2, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t40)
    %t41 = alloca i32, align 4
    %t42 = alloca i32, align 4
    store i32 10, i32* %t41, align 4
    store i32 5, i32* %t42, align 4
    %t43 = load i32, i32* %t41, align 4
    %t44 = load i32, i32* %t42, align 4
    %t45 = icmp sge i32 %t43, %t44
    %t46 = load i32, i32* %t41, align 4
    %t47 = load i32, i32* %t42, align 4
    %t48 = icmp eq i32 %t46, %t47
    %t49 = load i32, i32* %t41, align 4
    %t50 = load i32, i32* %t42, align 4
    %t51 = icmp sgt i32 %t49, %t50
    %t52 = and i1 %t48, %t51
    %t53 = or i1 %t45, %t52
    br i1 %t53, label %Ltrue12, label %Lfalse13
    Ltrue12:
    %t54 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.3, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t54)
    br label %Lend14
    Lfalse13:
    br label %Lend14
    Lend14:
    %t55 = alloca double, align 4
    store double 3.1415926, double* %t55, align 4
    %t56 = load double, double* %t55, align 4
    %t57 = fcmp oeq double %t56, 3.1415926
    br i1 %t57, label %Ltrue15, label %Lfalse16
    Ltrue15:
    %t58 = getelementptr inbounds [31 x i8], [31 x i8]* @.str.4, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t58)
    br label %Lend17
    Lfalse16:
    br label %Lend17
    Lend17:
    %t59 = alloca i32, align 4
    store i32 10, i32* %t59, align 4
    %t60 = load i32, i32* %t59, align 4
    %t61 = icmp sgt i32 %t60, 5
    br i1 %t61, label %Ltrue21, label %Lfalse22
    Ltrue21:
    %t62 = load i32, i32* %t59, align 4
    %t63 = icmp slt i32 %t62, 2
    br i1 %t63, label %Ltrue18, label %Lfalse19
    Ltrue18:
    %t64 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t64)
    br label %Lend20
    Lfalse19:
    %t65 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.6, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t65)
    br label %Lend20
    Lend20:
    br label %Lend23
    Lfalse22:
    br label %Lend23
    Lend23:
    %t66 = alloca i32, align 4
    %t67 = alloca i32, align 4
    store i32 10, i32* %t67, align 4
    %t68 = alloca i32, align 4
    %t69 = alloca i32, align 4
    store i32 1, i32* %t68, align 4
    store i32 1, i32* %t69, align 4
    store i32 0, i32* %t66, align 4
    br label %Lfor_cond24
    Lfor_cond24:
    %t70 = load i32, i32* %t66, align 4
    %t71 = load i32, i32* %t67, align 4
    %t72 = icmp slt i32 %t70, %t71
    br i1 %t72, label %Lfor_body25, label %Lfor_end27
    Lfor_body25:
    %t75 = alloca i32, align 4
    %t76 = load i32, i32* %t69, align 4
    store i32 %t76, i32* %t75, align 4
    %t77 = load i32, i32* %t68, align 4
    %t78 = load i32, i32* %t69, align 4
    %t79 = add i32 %t77, %t78
    store i32 %t79, i32* %t69, align 4
    %t80 = load i32, i32* %t75, align 4
    store i32 %t80, i32* %t68, align 4
    br label %Lfor_update26
    Lfor_update26:
    %t73 = load i32, i32* %t66, align 4
    %t74 = add i32 %t73, 1
    store i32 %t74, i32* %t66, align 4
    br label %Lfor_cond24
    Lfor_end27:
    %t81 = load i32, i32* %t69, align 4
    %t82 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.7, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t82, i32 %t81)
    %t83 = alloca i32, align 4
    store i32 10, i32* %t83, align 4
    %t84 = alloca i32, align 4
    %t85 = alloca i32, align 4
    store i32 1, i32* %t84, align 4
    store i32 1, i32* %t85, align 4
    br label %Lwhile_cond28
    Lwhile_cond28:
    %t86 = load i32, i32* %t83, align 4
    %t87 = icmp sgt i32 %t86, 0
    br i1 %t87, label %Lwhile_body29, label %Lwhile_end30
    Lwhile_body29:
    %t88 = load i32, i32* %t83, align 4
    %t89 = sub i32 %t88, 1
    store i32 %t89, i32* %t83, align 4
    %t90 = alloca i32, align 4
    %t91 = load i32, i32* %t85, align 4
    store i32 %t91, i32* %t90, align 4
    %t92 = load i32, i32* %t84, align 4
    %t93 = load i32, i32* %t85, align 4
    %t94 = add i32 %t92, %t93
    store i32 %t94, i32* %t85, align 4
    %t95 = load i32, i32* %t90, align 4
    store i32 %t95, i32* %t84, align 4
    br label %Lwhile_cond28
    Lwhile_end30:
    %t96 = load i32, i32* %t85, align 4
    %t97 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.8, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t97, i32 %t96)
    %t98 = alloca i32, align 4
    store i32 0, i32* %t98, align 4
    %t99 = alloca i32, align 4
    store i32 0, i32* %t99, align 4
    br label %Lwhile_cond31
    Lwhile_cond31:
    %t100 = icmp eq i32 1, 1
    br i1 %t100, label %Lwhile_body32, label %Lwhile_end33
    Lwhile_body32:
    %t101 = load i32, i32* %t99, align 4
    %t102 = add i32 %t101, 1
    store i32 %t102, i32* %t99, align 4
    %t103 = load i32, i32* %t98, align 4
    %t104 = icmp sgt i32 %t103, 10
    br i1 %t104, label %Ltrue34, label %Lfalse35
    Ltrue34:
    %t105 = load i32, i32* %t98, align 4
    %t106 = add i32 %t105, 1
    store i32 %t106, i32* %t98, align 4
    br label %Lend36
    Lfalse35:
    %t107 = load i32, i32* %t98, align 4
    %t108 = add i32 %t107, 2
    store i32 %t108, i32* %t98, align 4
    br label %Lend36
    Lend36:
    %t109 = load i32, i32* %t98, align 4
    %t110 = icmp eq i32 %t109, 20
    br i1 %t110, label %Ltrue37, label %Lfalse38
    Ltrue37:
    br label %Lwhile_end33
    br label %Lend39
    Lfalse38:
    br label %Lend39
    Lend39:
    br label %Lwhile_cond31
    Lwhile_end33:
    %t111 = load i32, i32* %t99, align 4
    %t112 = getelementptr inbounds [48 x i8], [48 x i8]* @.str.9, i64 0, i64 0
    call i32 (i8*, ...) @printf(i8* %t112, i32 %t111)
    ret i32 0
}
