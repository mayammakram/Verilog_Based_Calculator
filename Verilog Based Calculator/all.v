`timescale 1ns / 1ps

module all(
    input clock, 
    input rst, 
    output reg [3:0] anode, 
    output reg [6:0] Displayed_LED,
    output reg dp,
    input [3:0] btn,
    input s1, s2, s3, s4, s5
    );
    wire neg, error;
    reg [26:0] counter;
    wire enable;
    wire [15:0] number;
    reg [3:0] bcd;
    reg value;
    wire temp_dp;
    wire [15:0] intermediate_num;
    reg [19:0] refresh_counter;
    wire [1:0] activate_LED;          
      
        Num_counter o1(.btn(btn[0]), .rst(rst), .clk(clock), .digit(intermediate_num[3:0]));
        Num_counter o2(.btn(btn[1]), .rst(rst), .clk(clock), .digit(intermediate_num[7:4]));
        Num_counter o3(.btn(btn[2]), .rst(rst), .clk(clock), .digit(intermediate_num[11:8]));
        Num_counter o4(.btn(btn[3]), .rst(rst), .clk(clock), .digit(intermediate_num[15:12]));

        operations op1(s1, s2, s3, s4, s5, temp_dp, intermediate_num[15:12], intermediate_num[11:8], intermediate_num[7:4], intermediate_num[3:0], number[3:0], number[7:4], number[11:8], number[15:12], neg, error);
        
    always @(posedge clock or posedge rst)
    begin
        if(rst==1)
            counter <= 0;
        else begin
            if(counter>=99999999) 
                 counter <= 0;
            else
                counter <= counter + 1;
        end
    end 
    assign enable = (counter==99999999)?1:0;
    
    always @(posedge clock or posedge rst)
    begin 
        if(rst==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign activate_LED = refresh_counter[19:18];

    always @(*)
    begin
        case(activate_LED)
        2'b00: begin //ANODE 1 FROM LEFT
            anode = 4'b0111; 
            if (error == 0)
            bcd = number[15:12];
            else
            bcd = 4'b1010;
            value = 1'b1;
             end 
        2'b01: begin //ANODE 2 FROM LEFT
            anode = 4'b1011; 
            if (neg == 1)
            anode = 4'b1111;
            else if (error == 1)
            bcd = 4'b1100;
            else
            bcd = number[11:8];
            if (temp_dp == 1)
                value = 1'b0;
            else
            value = 1'b1;
                end
        2'b10: begin //ANODE 3 FROM LEFT
            anode = 4'b1101; 
            if (error == 0)
            bcd = number[7:4];
            else
            bcd = 4'b1100;

            value = 1'b1;
              end
        2'b11: begin //ANODE 4 FROM LEFT
            anode = 4'b1110; 
            if (error == 0)
             bcd = number[3:0];
             else
             bcd = 4'b1011;
             value = 1'b1;
               end   
               
        default:
        begin
            anode = 4'b0111; 
            bcd = number[15:11];
            value = 1'b1;
            end
        endcase
    end
    always @(*)
    begin
        case(bcd)
        4'b0000: Displayed_LED = 7'b0000001; // 0     
        4'b0001: Displayed_LED = 7'b1001111; // 1 
        4'b0010: Displayed_LED = 7'b0010010; // 2 
        4'b0011: Displayed_LED = 7'b0000110; // 3 
        4'b0100: Displayed_LED = 7'b1001100; // 4 
        4'b0101: Displayed_LED = 7'b0100100; // 5 
        4'b0110: Displayed_LED = 7'b0100000; // 6 
        4'b0111: Displayed_LED = 7'b0001111; // 7 
        4'b1000: Displayed_LED = 7'b0000000; // 8     
        4'b1001: Displayed_LED = 7'b0000100; // 9 
        4'b1111: Displayed_LED = 7'b1111110; // negative sign
        4'b1010: Displayed_LED = 7'b0110000; // E
        4'b1100: Displayed_LED = 7'b1111010; // r
        4'b1011: Displayed_LED = 7'b1111111; // Displays Nothing
        
        default: Displayed_LED = 7'b0000001; // 0
        endcase
        
        //Decimal Point Display
        case(value)
        1'b0: dp = 1'b0;
        1'b1: dp = 1'b1;
        endcase
    end
 endmodule
