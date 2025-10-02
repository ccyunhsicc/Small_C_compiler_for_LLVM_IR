// Global variable
//int test_num;
/*
// Function call
int add(int a, int b){
  return a +b;
}*/

/*// Structure data type
struct score{
  int student_ID;
  int student_score;
};*/

void main(){

  /* 5% */
  int num1;
  int num2;
  
  /* 10% */
  num1 = (2 + 10/5) - 1 * 5 % 7; // 1
  num2 = num1 + num1*2 - 4*7*num1/14; // 1
  
  
  /* 10 */
  if(num1 == num2){
    num1 = 5;
  }
  else{
    num2 = 10;
  }
  
  /* 10 */
  if(num1 <= num2)
    num1 = num2 - num1;
  else
    num2 = num1 - num2;
  
  /* 5 */
  if(num1 > (num2+1)){
    num1 = num2;
  }
  
  if(num1 != num2)
    num2 = 0;
  
  /* 5% */
  printf("num1: %d\n", num1); // 2
  printf("num2: %d\n", num2); // 2
  
  /* 5% */
  printf("baseline end\n");
  
  /*--------------bonus--------------*/
  
  /*// Global variable 1%
  test_num = 1;
  printf("Global variable %d\n", test_num);*/
  
  
  // Logical operation 3%
  int LO_num1;
  int LO_num2;
  LO_num1 = 10; LO_num2 = 5;
  if(LO_num1 >= LO_num2 || ((LO_num1 == LO_num2) && (LO_num1 > LO_num2))){
    printf("Logical operation pass\n");
  }
  
  
  // Floating point data type 3%
  double Float_num;
  Float_num = 3.1415926;
  if(Float_num == 3.1415926){
    printf("Floating point data type pass\n");
  }
  
  /*
  // Function call 3%
  printf("if %d = 7, Function call pass\n", add(3, 4));*/
  
  
  // 2-level nested if construct 3%
  int N_if_num1;
  N_if_num1 = 10;
  if(N_if_num1 > 5){
    if(N_if_num1 < 2){
      printf("error");
    }
    else{
      printf("Nested if construct pass\n");
    }
  }
  
  
  // For-loop construct 3%
  int idx;
  int times;
  times = 10;
  int num1_1;
  int num2_1;
  num1_1 = 1;
  num2_1 = 1;
  for(idx=0; idx<times; idx=idx+1){
    int tmp;
    tmp = num2_1;
    num2_1 = num1_1 + num2_1;
    num1_1 = tmp;
  }
  printf("if %d = 144, For-loop construct pass\n", num2_1);
  
  
  // while-loop construct 3%
  int times_1;
  times_1 = 10;
  int num1_2;
  int num2_2;
  num1_2 = 1;
  num2_2 = 1;
  while(times_1 > 0){
    times_1 = times_1 - 1;
    int tmp_1;
    tmp_1 = num2_2;
    num2_2 = num1_2 + num2_2;
    num1_2 = tmp_1;
  }
  printf("if %d = 144, while-loop construct pass\n", num2_2);
  
  
  // Loop construct + if construct 5%
  int LOOP_IF_num;
  LOOP_IF_num = 0;
  int count;
  count = 0;
  while(1 == 1){
    count = count + 1;
    if(LOOP_IF_num > 10){
      LOOP_IF_num = LOOP_IF_num + 1;
    }
    else{
      LOOP_IF_num = LOOP_IF_num + 2;
    }
    if(LOOP_IF_num == 20){
      break;
    }
  }
  printf("if %d = 14, Loop construct + if construct pass\n", count);
  
  /*
  // Switch-case construct 10%
  int score;
  score = 0;
  switch(score/10){
    case 10: case 9: case 8: 
      printf("A\n");
      break;
    case 7: 
      printf("B\n");
      break;
    case 6: 
      printf("C\n");
      break;
    default: 
      printf("F\n");
      break;
  }*/
  
  /*
  // Structure data type 15%
  struct score tmp = {613410000, 60};
  printf("ID: %d, score: %d\n", tmp.student_ID, tmp.student_score);*/
}

