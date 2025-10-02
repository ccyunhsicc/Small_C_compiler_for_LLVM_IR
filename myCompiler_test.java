import org.antlr.v4.runtime.*;
import java.util.ArrayList;
import java.util.List;

public class myCompiler_test {
	public static void main(String[] args) throws Exception {

      CharStream input = new ANTLRFileStream(args[0]);
      myCompilerLexer lexer = new myCompilerLexer(input);
      CommonTokenStream tokens = new CommonTokenStream(lexer);
 
      myCompilerParser parser = new myCompilerParser(tokens);
      parser.init();
      parser.program();
      
      /* Output text section */
      List<String> text_code = parser.getFinalTextCode();
	  
      /*for (int i=0; i < text_code.size(); i++)
         System.out.println(text_code.get(i));*/
      }
}
