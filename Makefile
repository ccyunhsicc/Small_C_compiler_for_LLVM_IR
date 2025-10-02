ANTLR_DIR = ./antlr-4.13.2-complete.jar

# 編譯目標 - 生成 LLVM IR
compile1:
	make clean
	java -jar $(ANTLR_DIR) myCompiler.g4
	javac -cp .:$(ANTLR_DIR) *.java
	java -cp .:$(ANTLR_DIR) myCompiler_test test1.c > test1.ll

compile2:
	make clean
	java -jar $(ANTLR_DIR) myCompiler.g4
	javac -cp .:$(ANTLR_DIR) *.java
	java -cp .:$(ANTLR_DIR) myCompiler_test test2.c > test2.ll

compile3:
	make clean
	java -jar $(ANTLR_DIR) myCompiler.g4
	javac -cp .:$(ANTLR_DIR) *.java
	java -cp .:$(ANTLR_DIR) myCompiler_test test3.c > test3.ll

compile4:
	make clean
	java -jar $(ANTLR_DIR) myCompiler.g4
	javac -cp .:$(ANTLR_DIR) *.java
	java -cp .:$(ANTLR_DIR) myCompiler_test testbench2.c > testbench.ll

# 執行 LLVM IR - 需要先編譯成可執行檔
run1: compile1
	lli test1.ll

run2: compile2
	lli test2.ll

run3: compile3
	lli test3.ll

run4: compile4
	lli testbench.ll

# 編譯 LLVM IR 成可執行檔 (可選)
exec1: compile1
	llc test1.ll -o test1.s
	gcc -no-pie test1.s -o test1
	./test1

exec2: compile2
	llc test2.ll -o test2.s
	gcc -no-pie test2.s -o test2
	./test2

exec3: compile3
	llc test3.ll -o test3.s
	gcc -no-pie test3.s -o test3
	./test3

exec4: compile4
	llc testbench.ll -o testbench.s
	gcc -no-pie testbench.s -o testbench
	./testbench

# 驗證 LLVM IR 語法
verify1: compile1
	llvm-as test1.ll -o /dev/null

verify2: compile2
	llvm-as test2.ll -o /dev/null

verify3: compile3
	llvm-as test3.ll -o /dev/null

verify4: compile4
	llvm-as testbench.ll -o /dev/null

# 清理檔案
clean:
	rm -f *.class *.tokens *.interp *.s test1 test2 test3 testbench
	find . -maxdepth 1 -name '*.java' ! -name 'myCompiler_test.java' -delete

# 全部測試
all: compile1 compile2 compile3 compile4

# 全部執行
run_all: run1 run2 run3 run4
