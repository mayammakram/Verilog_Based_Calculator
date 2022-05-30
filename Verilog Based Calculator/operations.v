`timescale 1ns/1ns

module operations(s1, s2, s3, s4, s5, temp_dp, one, two, three, four, op1, op2, op3, op4, neg, error);
input s1, s2, s3, s4, s5;
output reg temp_dp;
input [3:0] one; //1000
input [3:0] two; //0100
input [3:0] three; //0010
input [3:0] four; // 0001
output reg [3:0] op1;
output reg [3:0] op2;
output reg [3:0] op3;
output reg [3:0] op4;
output reg neg;
output reg error;
wire [6:0] digit1 = three*10 + four;// = a[7:4]*10 + a[3:0];
wire [6:0] digit2 = one*10 + two;// = b[7:4]*10 + b[3:0];
reg [3:0] savedvalue1;
reg [3:0] savedvalue2; 
reg [3:0] savedvalue3;
reg [3:0] savedvalue4;
integer temp;
integer mod;
integer remainder;
 
 
  always @(*)
    begin
    
    
    if(s5)
     begin
           op4 = one;
           op3 = two;
           op2 = three;
           op1 = four;
           temp_dp = 1;
     end

    
    else begin
    error = 0;
        
        if ((s1))
        begin
        temp = digit1 + digit2;
        op1 = temp % 10;
        temp = temp /10;
        op2 = temp % 10;
        temp = temp/10;
        op3 = temp%10;
        temp = temp/10;
        op4 = 0;
        neg = 0;
        temp_dp = 0;
        
        
        end
       
       
       
        else if (s2)
        begin
        if (digit2 >= digit1)
        begin
        temp = digit2 - digit1;
        op1 = temp % 10;
        temp = temp / 10;
        op2 = temp % 10;
        temp = temp / 10;
        op3 = 0;
        op4 = 0;
        neg = 0;
        temp_dp = 0;

        end
        else
        begin
        temp = digit1 - digit2;
        op1 = temp % 10;
        temp = temp / 10;
        op2 = temp % 10;
        op3 = 0;
        op4 = 0;
        neg = 1;
        temp_dp = 0;
        end
        end
     
      else if (s3)
      begin
      temp = digit1 * digit2;
      op1 = temp % 10;
      temp = temp / 10;
      op2 = temp % 10;
      temp = temp / 10;
      op3 = temp % 10;
      temp = temp / 10;
      op4 = temp % 10;
      neg = 0;
      temp_dp = 0;
      end
     
     
     
      else if (s4)
      begin
      if (digit1 == 0)
        error = 1;
      else error = 0;
      temp = digit2 / digit1;
      mod = digit2 % digit1;
      mod = mod * 10;
      remainder = mod / digit1;
      if (remainder >= 5)
        temp = temp + 1;
      op1 = temp % 10;
      temp = temp / 10;
      op2 = temp % 10;
      temp = temp / 10;
      op3 = temp % 10;
      temp = temp / 10;
      op4 = temp % 10;
      temp = temp / 10;
      neg = 0;
      temp_dp = 0;
      end
     
      else 
      begin
      op1 = digit1%10;
      temp = digit1/10;
      op2 = temp;
      op3 = digit2%10;
      temp = digit2/10;
      op4 = temp;
      neg = 0;
      temp_dp = 1;
      end
        end
   end 
endmodule