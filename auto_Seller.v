module auto_Seller( clk, reset, in_coin, in_choose, 
					out_nowMoney, out_canbuy, out_drink, out_coin );
					
input clk, reset ;
input[5:0] in_coin ; // 投入金額
input[2:0] in_choose ; // 選擇飲料
output reg[7:0] out_nowMoney ; // 現在投了多少$
output reg [2:0] out_canbuy, out_drink ;  // 顯示可購買飲料(S1), 選擇的飲料(S2)
output reg [7:0] out_coin ; // 找錢 (S3)


parameter S0 = 2'd0, // 初始狀態
		  S1 = 2'd1, // 選擇狀態
		  S2 = 2'd2, // 給予狀態
		  S3 = 2'd3; // 結帳狀態	  
		  
/*
	飲料A : 3'b001
	飲料B : 3'b010
	飲料C : 3'b011
	飲料D : 3'b100
*/

reg[2:0] choose ;
reg[1:0] state, next_state ;
reg[7:0] nowMoney ;

initial begin // 初始狀態
	state <= S0 ;
	next_state <= S0 ;
	nowMoney <= 6'd0 ;
	choose <= 3'd0 ;
	out_nowMoney <= 8'd0 ;
	out_canbuy <= 3'd0 ;
	out_drink <= 3'd0 ;
	out_coin <= 6'd0 ;
end

always @(posedge clk or posedge reset) 
begin
	if(reset)
		state <= S3 ;
	else
		state <= next_state ;
end

always @(state) // output
begin
	case (state)
		S0: out_coin = 6'd0 ;
		S1: if (nowMoney >= 8'd25) out_canbuy = 3'b100 ; // 飲料D
			else if (nowMoney >= 8'd20) out_canbuy = 3'b011 ; // 飲料C
			else if (nowMoney >= 8'd15) out_canbuy = 3'b010 ; // 飲料B
			else if (nowMoney >= 8'd10) out_canbuy = 3'b001 ; // 飲料A
			else out_canbuy = 3'b000 ;
		S2: if (choose == 3'b100) out_drink = 3'b100 ; // 飲料D
			else if (choose == 3'b011) out_drink = 3'b011 ; // 飲料C
			else if (choose == 3'b010) out_drink = 3'b010 ; // 飲料B
			else if (choose == 3'b001) out_drink = 3'b001 ; // 飲料A
			else out_drink = 3'b000 ;
		S3: begin
				if (choose == 3'b100) nowMoney = nowMoney - 6'd25 ; // 飲料D
				else if (choose == 3'b011) nowMoney = nowMoney - 6'd20 ; // 飲料C
				else if (choose == 3'b010) nowMoney = nowMoney - 6'd15 ; // 飲料B
				else if (choose == 3'b001) nowMoney = nowMoney - 6'd10 ; // 飲料A
				out_canbuy = 3'd0 ;
				out_drink = 3'b000 ;
				out_coin = nowMoney ;
				nowMoney = 8'd0 ;
				out_nowMoney = nowMoney ;
			end
	endcase
end

always @(state or in_coin or in_choose) // 轉換狀態
begin
	case (state)
		S0: begin
				nowMoney = nowMoney + in_coin ;
				out_nowMoney = nowMoney ;
				if(nowMoney >= 8'd10) next_state = S1 ;
				else next_state = S0 ;
			end
		S1: begin
				choose = in_choose ;
				if(choose != 3'd0) next_state = S2 ;
				else next_state = S0 ;
			end
		S2: next_state = S3 ; 
		S3: next_state = S0 ;
		default: next_state = S0 ;
	endcase
end
endmodule