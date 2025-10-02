grammar myCompiler;
options { language = Java; }
@header {
    import java.util.HashMap;
    import java.util.List;
    import java.util.ArrayList;
}
@members {
    enum TypeInfo { Int, Float, Double, Char, Void, Struct, Boolean, Error }
    class Info {
        TypeInfo theType;   
        int  varIndex;      // alloca/load/store 
        int  iValue;        // int value
        double fValue;      // double value
        String  tmp;        // LLVM IR tmp name
        boolean isConstant; // constant or not
    }
    HashMap<String, Info> symtab = new HashMap<>();
    List<List<String>> TextCodeBuffers = new ArrayList<>();
    List<String> currentTextCodeBuffer; 
    int tmpCnt = 0;   
    int labelCnt = 0; 
    int strCnt = 0; 
    List<String> stringDefs = new ArrayList<>(); 
    HashMap<String, String> stringLiterals = new HashMap<>(); 
    TypeInfo mainReturnType = TypeInfo.Void;
    public void init() {
        symtab.clear();
        TextCodeBuffers.clear();
        stringDefs.clear();
        stringLiterals.clear();
        tmpCnt = 0;
        labelCnt = 0;
        mainReturnType = TypeInfo.Void;
        TextCodeBuffers.add(new ArrayList<>());
        currentTextCodeBuffer = TextCodeBuffers.get(0);
    }
    String newTemp() { return "%t" + (tmpCnt++); }
    String newLabel(String base) { return base + (labelCnt++); }
    String toLLVMType(TypeInfo type) {
        switch (type) {
            case Int: return "i32";
            case Float: return "float";
            case Double: return "double";
            case Char: return "i8";
            case Boolean: return "i1"; 
            case Void: return "void";
            case Struct: return "i8*"; 
            case Error: return "i32"; 
            default: return "i32"; 
        }
    }
    void printHeader() {
        System.out.println("; ModuleID = 'main'");
        System.out.println("target triple = \"x86_64-pc-linux-gnu\"");
        System.out.println();
        System.out.println("@.str = private unnamed_addr constant [4 x i8] c\"%d\\0A\\00\", align 1");
        System.out.println("declare dso_local i32 @printf(i8*, ...) #1");
        System.out.println();
    }
    void addInstruction(String instr) {
        currentTextCodeBuffer.add(instr);
    }
    void pushBuffer() {
        List<String> newBuffer = new ArrayList<>();
        TextCodeBuffers.add(newBuffer);
        currentTextCodeBuffer = newBuffer;
    }
    List<String> popBuffer() {
        if (TextCodeBuffers.size() <= 1) {
            throw new IllegalStateException("Cannot pop the main TextCode buffer. Stack underflow.");
        }
        List<String> poppedBuffer = TextCodeBuffers.remove(TextCodeBuffers.size() - 1);
        currentTextCodeBuffer = TextCodeBuffers.get(TextCodeBuffers.size() - 1); 
        return poppedBuffer;
    }
    public List<String> getFinalTextCode() {
        if (TextCodeBuffers.isEmpty()) {
            return new ArrayList<>(); 
        }
        return TextCodeBuffers.get(0); 
    }
    List<String[]> loopLabelStack = new ArrayList<>();
    void pushLoopLabels(String breakLabel, String continueLabel) {
        loopLabelStack.add(new String[]{breakLabel, continueLabel});
    }
    void popLoopLabels() {
        if (!loopLabelStack.isEmpty()) {
            loopLabelStack.remove(loopLabelStack.size() - 1);
        }
    }
    String getCurrentBreakLabel() {
        if (loopLabelStack.isEmpty()) {
            return null; 
        }
        return loopLabelStack.get(loopLabelStack.size() - 1)[0];
    }
    String getCurrentContinueLabel() {
        if (loopLabelStack.isEmpty()) {
            return null; 
        }
        return loopLabelStack.get(loopLabelStack.size() - 1)[1];
    }
}
// =============================
// Parser Rules with LLVM IR Generation
// =============================
program
    : {init();printHeader();} externalDeclaration* EOF
        {
            if (mainReturnType == TypeInfo.Void || mainReturnType == TypeInfo.Int) {
                addInstruction("  ret i32 0");
            } else {
                addInstruction("  ret " + toLLVMType(mainReturnType) + " 0");
            }
            addInstruction("}"); 
            for (String def : stringDefs) {
                System.out.println(def);
            }
            System.out.println(); 
            for (String instr : currentTextCodeBuffer) { 
                if (instr.startsWith("define") || instr.equals("}")) {
                    System.out.println(instr);
                } else {
                    System.out.println("  " + instr);
                }
            }
        }
    ;

externalDeclaration
    : functionDefinition
    | declaration
    | structDefinition
    ;

structDefinition
    : 'struct' ID '{' structMember* '}' ';'
    ;

structMember
    : typeSpecifier declaratorList ';'
    ;

functionDefinition
    : t=typeSpecifier id=ID '(' parameterList? ')' 
      {
        if ($id.getText().equals("main")) {
            if ($t.type == TypeInfo.Void || $t.type == TypeInfo.Int) {
                mainReturnType = TypeInfo.Int;
            } else {
                System.out.println("Error! " + $t.start.getLine() + ": main function must have void or int return type.");
                mainReturnType = TypeInfo.Int; 
            }
        } else {
            mainReturnType = $t.type;
        }
        TypeInfo actualReturnType = $id.getText().equals("main") ? TypeInfo.Int : $t.type;
        addInstruction("define dso_local " + toLLVMType(actualReturnType) + " @" + $id.getText() + "() {");
        pushBuffer();
      }
      compoundStatement 
      {
        List<String> functionBodyIR = popBuffer();
        for (String instr : functionBodyIR) {
            addInstruction("  " + instr); 
        }
      }
    ;
parameterList
    : parameter (',' parameter)*
    ;
    
parameter
    : t=typeSpecifier id=ID
      {
        if (symtab.containsKey($id.getText())) {
            System.out.println("Error! " + $id.getLine() + ": Redeclared identifier " + $id.getText() + ".");
        } else {
            Info info = new Info();
            info.theType = $t.type;
            symtab.put($id.getText(), info);
        }
      }
    ;

declaration
    returns [TypeInfo type]
    : t=typeSpecifier dl=declaratorList ';'
      {
        $type = $t.type;
        for (int i = 0; i < $dl.ids.size(); i++) {
            String name = $dl.ids.get(i);
            Info initInfo = $dl.initInfos.get(i);
            if (symtab.containsKey(name)) {
                System.out.println("Error! " + $start.getLine() + ": Redeclared identifier " + name + ".");
            } else {
                Info info = new Info();
                info.theType = $type;
                String ptr = newTemp();
                addInstruction(ptr + " = alloca " + toLLVMType(info.theType) + ", align 4");
                info.tmp = ptr;
                if (initInfo != null) {
                    if (initInfo.theType == TypeInfo.Error) {
                        System.out.println("Error! " + $start.getLine() + ": Invalid initializer for " + name + ".");
                    } else if (info.theType != initInfo.theType && 
                              !(info.theType == TypeInfo.Int && initInfo.theType == TypeInfo.Char)) {
                        System.out.println("Error! " + $start.getLine() + ": Type mismatch in initialization of " + name + ".");
                    } else {
                        addInstruction("store " + toLLVMType(initInfo.theType) + " " + initInfo.tmp + ", " + toLLVMType(info.theType) + "* " + ptr + ", align 4");
                    }
                }
                symtab.put(name, info);
            }
        }
      }
    ;

declaratorList
    returns [java.util.List<String> ids, java.util.List<Info> initInfos]
    : d=declarator 
      { 
        $ids = new java.util.ArrayList<>(); 
        $initInfos = new java.util.ArrayList<>();
        $ids.add($d.id); 
        $initInfos.add($d.initInfo);
      }
      (',' d2=declarator 
      { 
        $ids.add($d2.id); 
        $initInfos.add($d2.initInfo);
      })*
    ;

declarator
    returns [String id, Info initInfo]
    : idTok=ID 
      { 
        $id = $idTok.getText(); 
        $initInfo = null; 
      }
      ('=' init=initializer 
      { 
        $initInfo = $init.info; 
      })?
    ;

initializer
    returns [Info info]
    : '{' e1=expression 
      { 
        $info = new Info();
        $info.theType = $e1.type;
        $info.tmp = $e1.tmp;
      }
      (',' expression)* '}' 
    | e=expression 
      { 
        $info = new Info();
        $info.theType = $e.type;
        $info.tmp = $e.tmp;
      }
    ;

typeSpecifier
    returns [TypeInfo type]
    : 'int'    { $type = TypeInfo.Int; }
    | 'float'  { $type = TypeInfo.Float; }
    | 'double' { $type = TypeInfo.Double; }
    | 'char'   { $type = TypeInfo.Char; }
    | 'void'   { $type = TypeInfo.Void; }
    | 'struct' ID { $type = TypeInfo.Struct; }
    ;

compoundStatement
    : '{' blockItem* '}'
    ;

blockItem
    : declaration
    | statement
    ;

statement
    : compoundStatement
    | expressionStatement
    | ifStatement
    | forStatement
    | whileStatement
    | breakStatement
    | continueStatement  
    | returnStatement
    | switchStatement
    | printfStatement
    ;

expressionStatement
    : expression? ';'
    ;

ifStatement
    : 'if' '(' e=expression ')' 
      { List<String> s1_IR = null; List<String> s2_IR = null; } // 初始化為 null
      { pushBuffer(); }
      s1=statement
      { s1_IR = popBuffer(); } 
      ('else'
        { pushBuffer(); }
        s2=statement
        { s2_IR = popBuffer(); } 
      )?
      {
        if ($e.type != TypeInfo.Boolean && $e.type != TypeInfo.Error) {
            System.out.println("Error! " + $e.start.getLine() + ": condition of if must be boolean.");
        } else if ($e.type == TypeInfo.Boolean) {
            String trueLabel = newLabel("Ltrue");
            String falseLabel = newLabel("Lfalse");
            String endLabel = newLabel("Lend");
            addInstruction("br i1 " + $e.tmp + ", label %" + trueLabel + ", label %" + falseLabel);
            addInstruction(trueLabel + ":");
            for (String instr : s1_IR) { 
                addInstruction(instr);
            }
            addInstruction("br label %" + endLabel);
            addInstruction(falseLabel + ":");
            if (s2_IR != null) { 
                for (String instr : s2_IR) { 
                    addInstruction(instr);
                }
                addInstruction("br label %" + endLabel);
            } else {
                addInstruction("br label %" + endLabel);
            }
            addInstruction(endLabel + ":");
        }
      }
    ;

forStatement
    : 'for' '(' 
      { pushBuffer(); }
      e1=expression? 
      { List<String> initIR = popBuffer(); }
      ';' 
      { pushBuffer(); }
      e2=expression? 
      { List<String> conditionIR = popBuffer(); }
      ';' 
      { pushBuffer(); }
      e3=expression? 
      { List<String> updateIR = popBuffer(); }
      ')' 
      {
        String condLabel = newLabel("Lfor_cond");
        String bodyLabel = newLabel("Lfor_body");
        String updateLabel = newLabel("Lfor_update");
        String endLabel = newLabel("Lfor_end");
        pushLoopLabels(endLabel, updateLabel);
      }
      { pushBuffer(); }
      s=statement
      { 
        List<String> bodyIR = popBuffer(); 
        popLoopLabels();
      }
      {
        if ($e2.ctx != null && $e2.type != null && $e2.type != TypeInfo.Boolean && $e2.type != TypeInfo.Error) {
            System.out.println("Error! " + $e2.start.getLine() + ": condition of for must be boolean.");
        } else {
            if ($e1.ctx != null && initIR != null) {
                for (String instr : initIR) {
                    addInstruction(instr);
                }
            }
            addInstruction("br label %" + condLabel);
            addInstruction(condLabel + ":");
            if ($e2.ctx != null && conditionIR != null) {
                String conditionResult = null;
                for (String instr : conditionIR) {
                    addInstruction(instr);
                    if (instr.contains(" = ")) {
                        String[] parts = instr.split(" = ");
                        if (parts.length > 0) {
                            conditionResult = parts[0].trim();
                        }
                    }
                }
                if (conditionResult == null) {
                    conditionResult = $e2.tmp;
                }
                addInstruction("br i1 " + conditionResult + ", label %" + bodyLabel + ", label %" + endLabel);
            } else {
                addInstruction("br label %" + bodyLabel);
            }
            addInstruction(bodyLabel + ":");
            if (bodyIR != null) {
                for (String instr : bodyIR) {
                    addInstruction(instr);
                }
            }
            addInstruction("br label %" + updateLabel);
            addInstruction(updateLabel + ":");
            if ($e3.ctx != null && updateIR != null) {
                for (String instr : updateIR) {
                    addInstruction(instr);
                }
            }
            addInstruction("br label %" + condLabel);
            addInstruction(endLabel + ":");
        }
      }
    ;

whileStatement
    : 'while' '(' 
      { pushBuffer(); }
      e=expression
      { List<String> conditionIR = popBuffer(); }
      ')' 
      {
        String condLabel = newLabel("Lwhile_cond");
        String bodyLabel = newLabel("Lwhile_body");
        String endLabel = newLabel("Lwhile_end");
        pushLoopLabels(endLabel, condLabel);
      }
      { pushBuffer(); }
      s=statement
      { 
        List<String> bodyIR = popBuffer(); 
        popLoopLabels();
      }
      {
        if ($e.type != null && $e.type != TypeInfo.Boolean && $e.type != TypeInfo.Error) {
            System.out.println("Error! " + $e.start.getLine() + ": condition of while must be boolean.");
        } else if ($e.type == TypeInfo.Boolean) {
            addInstruction("br label %" + condLabel);
            addInstruction(condLabel + ":");
            String conditionResult = null;
            for (String instr : conditionIR) {
                addInstruction(instr);
                if (instr.contains(" = ")) {
                    String[] parts = instr.split(" = ");
                    if (parts.length > 0) {
                        conditionResult = parts[0].trim();
                    }
                }
            }
            if (conditionResult == null) {
                conditionResult = $e.tmp;
            }
            addInstruction("br i1 " + conditionResult + ", label %" + bodyLabel + ", label %" + endLabel);
            addInstruction(bodyLabel + ":");
            for (String instr : bodyIR) {
                addInstruction(instr);
            }
            addInstruction("br label %" + condLabel);
            addInstruction(endLabel + ":");
        }
      }
    ;

breakStatement
    : 'break' ';'
      {
        String breakLabel = getCurrentBreakLabel();
        if (breakLabel == null) {
            System.out.println("Error! " + $start.getLine() + ": 'break' statement not within a loop.");
        } else {
            addInstruction("br label %" + breakLabel);
        }
      }
    ;

continueStatement
    : 'continue' ';'
      {
        String continueLabel = getCurrentContinueLabel();
        if (continueLabel == null) {
            System.out.println("Error! " + $start.getLine() + ": 'continue' statement not within a loop.");
        } else {
            addInstruction("br label %" + continueLabel);
        }
      }
    ;

returnStatement
    : 'return' e=expression? ';'
      {
        if ($e.ctx != null) {
            addInstruction("ret " + toLLVMType($e.type) + " " + $e.tmp);
        } else {
            addInstruction("ret void");
        }
      }
    ;

switchStatement
    : 'switch' '(' e=expression ')' '{' switchBlock* '}'
    ;
    
switchBlock
    : switchLabel+ blockItem*
    ;
    
switchLabel
    : 'case' constantExpression ':'
    | 'default' ':'
    ;

printfArgs returns [List<Info> argList]
    : { $argList = new ArrayList<>(); }
      e1=expression
      {
          Info info1 = new Info();
          info1.theType = $e1.type;
          info1.tmp = $e1.tmp;
          $argList.add(info1);
      }
      (',' e2=expression
      {
          Info info2 = new Info();
          info2.theType = $e2.type;
          info2.tmp = $e2.tmp;
          $argList.add(info2);
      }
      )*
    ;

printfStatement
    : 'printf' '(' format=STRINGLITERALS (',' args=printfArgs)? ')' ';'
      {
          String rawString = $format.getText();
          String processedString = rawString.substring(1, rawString.length() - 1).replace("\\n", "\n");
          String llvmString = processedString.replace("\n", "\\0A") + "\\00";
          int strLen = processedString.length() + 1; 
          String strVar;
          if (stringLiterals.containsKey(processedString)) {
              strVar = stringLiterals.get(processedString);
          } else {
              strVar = "@.str." + (strCnt++);
              stringLiterals.put(processedString, strVar);
              String strDef = strVar + " = private unnamed_addr constant [" + strLen + " x i8] c\"" + llvmString + "\", align 1";
              stringDefs.add(strDef); 
          }
          String strPtr = newTemp();
          addInstruction(strPtr + " = getelementptr inbounds [" + strLen + " x i8], [" + strLen + " x i8]* " + strVar + ", i64 0, i64 0");
          StringBuilder call = new StringBuilder();
          call.append("call i32 (i8*, ...) @printf(i8* " + strPtr);
          if ($args.ctx != null) {
              for (Info argInfo : $args.argList) {
                  call.append(", ")
                      .append(toLLVMType(argInfo.theType))
                      .append(" ")
                      .append(argInfo.tmp);
              }
          }
          call.append(")");
          addInstruction(call.toString());
      }
    ;
expression
    returns [TypeInfo type, String tmp]
    : a=assignmentExpression { $type = $a.type; $tmp = $a.tmp; }
    ;

assignmentExpression
    returns [TypeInfo type, String tmp]
    : id=ID '=' b=assignmentExpression
      {
        Info info = symtab.get($id.getText());
        if (info == null) {
            System.out.println("Error! " + $id.getLine() + ": Undeclared identifier " + $id.getText() + ".");
            $type = TypeInfo.Error;
        }
        else if (info.theType == TypeInfo.Error || $b.type == TypeInfo.Error ||
                 (info.theType != $b.type && !(info.theType == TypeInfo.Int && $b.type == TypeInfo.Char))) {
            System.out.println("Error! " + $b.start.getLine() + ": assignment types must match.");
            $type = TypeInfo.Error;
        } else {
            addInstruction("store " + toLLVMType($b.type) + " " + $b.tmp + ", " + toLLVMType(info.theType) + "* " + info.tmp + ", align 4");
            $type = info.theType;
            $tmp = $b.tmp;  
        }
      }
    | a=logicalOrExpression
      { $type = $a.type; $tmp = $a.tmp; }
    ;

logicalOrExpression
    returns [TypeInfo type, String tmp]
    : a=logicalAndExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op='||' b=logicalAndExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Boolean || $b.type != TypeInfo.Boolean) {
              System.out.println("Error! " + $start.getLine() + ": '||' operands must be boolean.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              addInstruction(result + " = or i1 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Boolean;
              $tmp = result;
          }
        }
      )*
    ;

logicalAndExpression
    returns [TypeInfo type, String tmp]
    : a=bitwiseOrExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op='&&' b=bitwiseOrExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Boolean || $b.type != TypeInfo.Boolean) {
              System.out.println("Error! " + $start.getLine() + ": '&&' operands must be boolean.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              addInstruction(result + " = and i1 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Boolean;
              $tmp = result;
          }
        }
      )*
    ;

bitwiseOrExpression
    returns [TypeInfo type, String tmp]
    : a=bitwiseXorExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op='|' b=bitwiseXorExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Int || $b.type != TypeInfo.Int) {
              System.out.println("Error! " + $start.getLine() + ": '|' requires int operands.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              addInstruction(result + " = or i32 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Int;
              $tmp = result;
          }
        }
      )*
    ;

bitwiseXorExpression
    returns [TypeInfo type, String tmp]
    : a=bitwiseAndExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op='^' b=bitwiseAndExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Int || $b.type != TypeInfo.Int) {
              System.out.println("Error! " + $start.getLine() + ": '^' requires int operands.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              addInstruction(result + " = xor i32 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Int;
              $tmp = result;
          }
        }
      )*
    ;

bitwiseAndExpression
    returns [TypeInfo type, String tmp]
    : a=shiftExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op='&' b=shiftExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Int || $b.type != TypeInfo.Int) {
              System.out.println("Error! " + $start.getLine() + ": '&' requires int operands.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              addInstruction(result + " = and i32 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Int;
              $tmp = result;
          }
        }
      )*
    ;

shiftExpression
    returns [TypeInfo type, String tmp]
    : a=relationalExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op=('<<' | '>>') b=relationalExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != TypeInfo.Int || $b.type != TypeInfo.Int) {
              System.out.println("Error! " + $start.getLine() + ": '" + $op.getText() + "' requires int operands.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              String llvmOp = $op.getText().equals("<<") ? "shl" : "ashr";
              addInstruction(result + " = " + llvmOp + " i32 " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Int;
              $tmp = result;
          }
        }
      )*
    ;

relationalExpression
    returns [TypeInfo type, String tmp]
    : a=additiveExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op=('<' | '>' | '<=' | '>=' | '==' | '!=') b=additiveExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) $type = TypeInfo.Error;
          else if ($type != $b.type) {
              System.out.println("Error! " + $start.getLine() + ": '" + $op.getText() + "' operands must have same type.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              String llvmOp = "";
              String llvmType = toLLVMType($type);
              switch ($op.getText()) {
                  case "<": llvmOp = llvmType.equals("i32") ? "icmp slt" : "fcmp olt"; break;
                  case ">": llvmOp = llvmType.equals("i32") ? "icmp sgt" : "fcmp ogt"; break;
                  case "<=": llvmOp = llvmType.equals("i32") ? "icmp sle" : "fcmp ole"; break;
                  case ">=": llvmOp = llvmType.equals("i32") ? "icmp sge" : "fcmp oge"; break;
                  case "==": llvmOp = llvmType.equals("i32") ? "icmp eq" : "fcmp oeq"; break;
                  case "!=": llvmOp = llvmType.equals("i32") ? "icmp ne" : "fcmp one"; break;
              }
              addInstruction(result + " = " + llvmOp + " " + llvmType + " " + $tmp + ", " + $b.tmp);
              $type = TypeInfo.Boolean;
              $tmp = result;
          }
        }
      )*
    ;

additiveExpression
    returns [TypeInfo type, String tmp]
    : a=multiplicativeExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op=('+'|'-') b=multiplicativeExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) { 
              $type = TypeInfo.Error; 
          }
          else if ($type != $b.type || !($type == TypeInfo.Int || $type == TypeInfo.Float || $type == TypeInfo.Double)) {
              System.out.println("Error! " + $start.getLine() + ": '" + $op.getText() + "' requires numeric same type.");
              $type = TypeInfo.Error;
          } else {
              String result = newTemp();
              String llvmOp = $op.getText().equals("+") ? "add" : "sub";
              String llvmType = toLLVMType($type);
              if ($type == TypeInfo.Float || $type == TypeInfo.Double) {
                  llvmOp = "f" + llvmOp;
              }
              addInstruction(result + " = " + llvmOp + " " + llvmType + " " + $tmp + ", " + $b.tmp);
              $type = $a.type;
              $tmp = result;
          }
        }
      )*
    ;

multiplicativeExpression
    returns [TypeInfo type, String tmp]
    : a=unaryExpression { $type = $a.type; $tmp = $a.tmp; }
      ( op=('*'|'/'|'%') b=unaryExpression
        {
          if ($type == TypeInfo.Error || $b.type == TypeInfo.Error) { 
              $type = TypeInfo.Error; 
          }
          else if ($op.getText().equals("%")) {
              if ($type != TypeInfo.Int || $b.type != TypeInfo.Int) {
                  System.out.println("Error! " + $start.getLine() + ": '%' requires int operands.");
                  $type = TypeInfo.Error;
              } else {
                  String result = newTemp();
                  addInstruction(result + " = srem i32 " + $tmp + ", " + $b.tmp);
                  $type = TypeInfo.Int;
                  $tmp = result;
              }
          } else {
              if ($type != $b.type || !($type == TypeInfo.Int || $type == TypeInfo.Float || $type == TypeInfo.Double)) {
                  System.out.println("Error! " + $start.getLine() + ": '" + $op.getText() + "' requires numeric same type.");
                  $type = TypeInfo.Error;
              } else {
                  String result = newTemp();
                  String llvmOp = $op.getText().equals("*") ? "mul" : "div";
                  String llvmType = toLLVMType($type);
                  if ($type == TypeInfo.Float || $type == TypeInfo.Double) {
                      llvmOp = "f" + llvmOp;
                  } else if ($op.getText().equals("/")) {
                      llvmOp = "sdiv"; // signed division for integers
                  }
                  addInstruction(result + " = " + llvmOp + " " + llvmType + " " + $tmp + ", " + $b.tmp);
                  $type = $a.type;
                  $tmp = result;
              }
          }
        }
      )*
    ;
    
unaryExpression
    returns [TypeInfo type, String tmp]
    : op=('+' | '-' | '!' | '~') e=unaryExpression
      {
        if ($e.type == TypeInfo.Error) {
            $type = TypeInfo.Error;
        } else {
            String o = $op.getText();
            if (o.equals("~")) {
                if ($e.type != TypeInfo.Int) {
                    System.out.println("Error! " + $start.getLine() + ": '~' requires int operand.");
                    $type = TypeInfo.Error;
                } else {
                    String result = newTemp();
                    addInstruction(result + " = xor i32 " + $e.tmp + ", -1");
                    $type = TypeInfo.Int;
                    $tmp = result;
                }
            }
            else if (o.equals("!")) {
                if ($e.type != TypeInfo.Boolean) {
                    System.out.println("Error! " + $start.getLine() + ": '!' requires boolean operand.");
                    $type = TypeInfo.Error;
                } else {
                    String result = newTemp();
                    addInstruction(result + " = xor i1 " + $e.tmp + ", true");
                    $type = TypeInfo.Boolean;
                    $tmp = result;
                }
            }
            else if (o.equals("-")) {
                if ($e.type != TypeInfo.Int && $e.type != TypeInfo.Float && $e.type != TypeInfo.Double) {
                    System.out.println("Error! " + $start.getLine() + ": '-' requires numeric operand.");
                    $type = TypeInfo.Error;
                } else {
                    String result = newTemp();
                    String llvmType = toLLVMType($e.type);
                    String llvmOp = ($e.type == TypeInfo.Float || $e.type == TypeInfo.Double) ? "fsub" : "sub";
                    String zero = ($e.type == TypeInfo.Float) ? "0.0" : ($e.type == TypeInfo.Double) ? "0.0" : "0";
                    addInstruction(result + " = " + llvmOp + " " + llvmType + " " + zero + ", " + $e.tmp);
                    $type = $e.type;
                    $tmp = result;
                }
            }
            else { // '+' unary plus
                $type = $e.type;
                $tmp = $e.tmp;
            }
        }
      }
    | p=primaryExpression
      {
        $type = $p.type;
        $tmp = $p.tmp;
      }
    ;
    
primaryExpression
    returns [TypeInfo type, String tmp]
    : id=ID
      {
        if (symtab.containsKey($id.getText())) { 
            Info info = symtab.get($id.getText());
            $type = info.theType;
            // Generate load instruction using the variable's allocated address
            String result = newTemp();
            addInstruction(result + " = load " + toLLVMType($type) + ", " + toLLVMType($type) + "* " + info.tmp + ", align 4");
            $tmp = result;
        }
        else {
            System.out.println("Error! " + $id.getLine() + ": Undeclared identifier " + $id.getText() + ".");
            $type = TypeInfo.Error;
        }
      }
    | c=constant { $type = $c.type; $tmp = $c.value; }
    | '(' e=expression ')' { $type = $e.type; $tmp = $e.tmp; }
    ;

constant
    returns [TypeInfo type, String value]
    : DEC_NUM       { $type = TypeInfo.Int; $value = $DEC_NUM.getText(); }
    | c=FLOAT_NUM   {
          String txt = $c.getText().toLowerCase();
          if (txt.endsWith("f")) {
              $type = TypeInfo.Float;
              $value = txt;
          } else {
              $type = TypeInfo.Double;
              $value = txt;
          }
      }
    | CHARLITERALS  { $type = TypeInfo.Char; $value = String.valueOf((int)$CHARLITERALS.getText().charAt(1)); }
    ;

constantExpression
    : expression
    ;
/*----------------------*/
/*       Keywords       */
/*----------------------*/
IF_TH     : 'if';
ELSE_TH   : 'else';
SWITCH_T  : 'switch';
CASE_T    : 'case';
FOR_T     : 'for';
WHILE_T   : 'while';
DO_T      : 'do';
GOTO_T    : 'goto';
RETURN_T  : 'return';
CONST_T   : 'const';
SIZEOF_T  : 'sizeof';
AUTO_T    : 'auto';
BREAK_T   : 'break';
CONTINUE_T: 'continue';
DEFAULT_T : 'default';
ENUM_T    : 'enum';
EXTERN_T  : 'extern';
REGISTER_T: 'register';
STATIC_T  : 'static';
STRUCT_T  : 'struct';
TYPEDEF_T : 'typedef';
UNION_T   : 'union';
VOLATILE_T: 'volatile';
NULL      : 'NULL';

/*---other keyword---*/
INCLUDE_H : 'include';
ELSEIF_H  : 'elif';
ENDIF_H   : 'endif';
IFDEF_H   : 'ifdef';
IFNDEF_H  : 'ifndef';
DEFINE_H  : 'define';
UNDEF_H   : 'undef';
LINE_H    : 'line';
ERROR_H   : 'error';
PROGMA_H  : 'progma';

/*----------------------*/
/*       Data Type      */
/*----------------------*/
INT_TYPE  : 'int';
CHAR_TYPE : 'char';
VOID_TYPE : 'void';
FLOAT_TYPE: 'float';
DOUBLE_TYPE: 'double';
LONG_TYPE : 'long';
SHORT_TYPE: 'short';
UNSIGNED_TYPE: 'unsigned';
SIGNED_TYPE: 'signed';

/*----------------------*/
/*       Operators      */
/*----------------------*/
/*--sort by precedence--*/
PLUSPLUS  : '++';
MINUSMINUS: '--';
POINTTO   : '->';
PLUS      : '+';
MINUS     : '-';
LOGICNOT  : '!';
BITNOT    : '~';
MUL_POINTER: '*';
BITAND_ADDRESS: '&';
DIV       : '/';
MODULE    : '%';
BITRSHIFT : '<<';
BITLSHIFT : '>>';
LT        : '<';
GT        : '>';
LEQ       : '<=';
GEQ       : '>=';
EQ        : '==';
NEQ       : '!=';
BITXOR    : '^';
BITOR     : '|';
LOGICAND  : '&&';
LOGICOR   : '||';
TERNARY_QM: '?';
TERNARY_CL: ':';
ASSIGN    : '=';
PLUSEQ    : '+=';
MINUSEQ   : '-=';
MULEQ     : '*=';
DIVEQ     : '/=';
MODULEEQ  : '%=';
BITANDEQ  : '&=';
BITXOREQ  : '^=';
BITOREQ   : '|=';
BITRSHIFTEQ: '<<=';
BITLSHIFTEQ: '>>=';

/*---other operator---*/
LPAR      : '(';
RPAR      : ')';
LBRACKET  : '[';
RBRACKET  : ']';
LBRACE    : '{';
RBRACE    : '}';
COMMA     : ',';
SEMICOLON : ';';
PERIOD    : '.';
QUOTE     : '"';
APOST     : '\'';
SHARP     : '#';
BACKSLASH : '\\';

/*----------------------*/
/*       Literals       */
/*----------------------*/
HEADERFILE: '<'((LETTER)+ '/')*(LETTER)+'.h>';
STRINGLITERALS : '"'(.)*?'"';
CHARLITERALS: '\'' ( ~['\\] | '\\' . ) '\'';
fragment LETTER: 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT: '0'..'9';

/*----------------------*/
/*       Numbers        */
/*----------------------*/
DEC_NUM : ('0' | ('1'..'9')(DIGIT)*);
FLOAT_NUM: FLOAT_NUM1 | FLOAT_NUM2 | FLOAT_NUM3;
fragment FLOAT_NUM1: (DIGIT)+'.'(DIGIT)*('f')?;
fragment FLOAT_NUM2: '.'(DIGIT)+('f')?;
fragment FLOAT_NUM3: (DIGIT)+('f')?;

/*----------------------*/
/*     Identifiers      */
/*----------------------*/
ID: (LETTER)(LETTER | DIGIT)*;
 
/*----------------------*/
/*       Comments       */
/*----------------------*/
COMMENT1 : '//' ~[\r\n]* -> skip;
COMMENT2 : '/*' .*? '*/' -> skip;

/*----------------------*/
/*        Whites        */
/*----------------------*/
NEW_LINE: '\n' -> skip;
WS  : (' '|'\r'|'\t')+ -> skip;
