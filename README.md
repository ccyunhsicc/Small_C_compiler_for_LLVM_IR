# Small_C_compiler_for_LLVM_IR

以 **Java 11 + ANTLR 4** 開發的 C 子集合編譯器，將 `.c` 轉為 **LLVM IR (`.ll`)**，並支援以 `lli` 直接執行、或經 `llc + gcc` 產生本機可執行檔。

---

## 環境

* Java：**openjdk 11.0.26**（2025-01-21）
* ANTLR：**4.13.2**
* 作業系統：**Ubuntu 22.04**（VMware）
* LLVM 工具鏈：`lli`, `llc`, `llvm-as`
* 其他：`gcc`, `make`

> 若環境未就緒，請先安裝上述工具並確保它們在 `PATH` 中。

---

## 測試檔

* 自行撰寫：`test1.c`, `test2.c`, `test3.c`
* 公開測試：`testbench2.c`

---

## 快速開始

```bash
# 編譯所有預設測試檔為 LLVM IR
make all

# 逐一執行所有 .ll（使用 lli）
make run_all
```

---

## Make 指令一覽

### 1) 編譯 C → LLVM IR

* `make compile1`：`test1.c` → `test1.ll`
* `make compile2`：`test2.c` → `test2.ll`
* `make compile3`：`test3.c` → `test3.ll`
* `make compile4`：`testbench2.c` → `testbench.ll`

> 通用寫法：`make compile<N>`

### 2) 直接執行 LLVM IR（`lli`）

* `make run1`：執行 `test1.ll`
* `make run2`：執行 `test2.ll`
* `make run3`：執行 `test3.ll`
* `make run4`：執行 `testbench.ll`

> 通用寫法：`make run<N>`

### 3) 產生並執行可執行檔（`llc` → `.s` → `gcc`）

* `make exec1`：`test1.ll` → 可執行檔 `test1` → 執行
* `make exec2`：`test2.ll` → 可執行檔 `test2` → 執行
* `make exec3`：`test3.ll` → 可執行檔 `test3` → 執行
* `make exec4`：`testbench.ll` → 可執行檔 `testbench` → 執行

> 通用寫法：`make exec<N>`

### 4) 驗證 LLVM IR 語法（`llvm-as`）

* `make verify1`：驗證 `test1.ll`
* `make verify2`：驗證 `test2.ll`
* `make verify3`：驗證 `test3.ll`
* `make verify4`：驗證 `testbench.ll`

> 通用寫法：`make verify<N>`

### 5) 其他

* `make clean`：清理產物（`.class`, `.tokens`, `.interp`, `.ll`, `.s`，以及 `test1/test2/test3/testbench` 可執行檔）
* `make all`：批次產生 `test1.ll`, `test2.ll`, `test3.ll`, `testbench.ll`
* `make run_all`：批次以 `lli` 執行所有 `.ll`

---

## 輸出與錯誤格式

* 正常：程式執行輸出（標準輸出/錯誤）
* 錯誤訊息格式：

```
Error! <line number>: <error message>
```

---

## 功能支援狀態

**已實作（公告額外 + 其他額外）**

* Logical operations
* Floating-point data type
* 2-level nested `if` construct
* `for` loop construct
* `while` loop construct
* loop + `if` 組合
* 位元運算（bitwise operations）

**未支援**

* `struct`（結構）
* 全域變數
* `switch-case` construct
* 函式呼叫（function call）

---

## 小提醒

* `compile4/run4/exec4/verify4` 目標對應 **`testbench2.c` ↔ `testbench.ll`/`testbench`**。
* 若 `llvm-as` 驗證失敗，請先檢查產生之 `.ll` 是否符合法規格（特別是型別與指令格式）。














