module stimulus;

reg clk, reset ;
reg[5:0] in_coin ; // 投錢
reg[2:0] in_choose ; //選飲料
wire[7:0] out_nowMoney ; // 現在投了多少$
wire[2:0] out_canbuy, out_drink ; // 顯示可購買飲料(S1), 選擇的飲料(S2)
wire[7:0] out_coin ;  // 找錢 (S3)

auto_Seller buy(clk, reset, in_coin, in_choose, 
				out_nowMoney, out_canbuy, out_drink, out_coin) ;
				
initial clk = 1'b1;
always #5 clk = ~clk;

initial
begin
// ----------歸0---------- //
reset = 1'b0;
in_choose = 3'b000 ; 
in_coin = 6'd0 ; 

// ----------狀況1---------- //  共投15元，買10元飲料，找零5元
in_coin = 6'd5 ; // 投5
#10 // S0
in_coin = 6'd10 ; // 投10
#10 // S1
in_choose = 3'b001 ; // input選A飲料   // output可選15塊以下飲料
in_coin = 6'd0 ;     // 沒投錢
#10 // S2  // output給予A飲料
#10 // S3  // output找零 5塊
in_choose = 3'b000 ; // 選擇歸0
#30 // S0
// ------------------------- //

// ----------狀況2---------- //  共投20元，買20元飲料，找零0元
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b011 ; // input選C飲料  // output可選20塊以下飲料
in_coin = 6'd0 ;     // 沒投錢
#10 // S2  // output給予C飲料
#10 // S3  // output找零 0塊
in_choose = 3'b000 ; // 選擇歸0
#30 // S0
// ------------------------- //

// ----------狀況3---------- //  共投66元，買25元飲料，找零41元
in_coin = 6'd5 ;  // 投5
#10 // S0
in_coin = 6'd1 ;  // 投1
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇  	  // output可選15塊以下飲料
#10 // S0
in_coin = 6'd50 ;  // 投50
#10 // S1
in_choose = 3'b100 ; // input選D飲料  // output可選25塊以下飲料
in_coin = 6'd0 ;     // 沒投錢
#10 // S2  // output給予D飲料
#10 // S3  // output找零 41塊
in_choose = 3'b000 ; // 選擇歸0
#30 // S0
// ------------------------- //

// ----------狀況4---------- //  共投47元，退幣，找零47元
in_coin = 6'd5 ;  // 投5
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選15塊以下飲料
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選25塊以下飲料
#10 // S0
in_coin = 6'd1 ;  // 投1
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選25塊以下飲料
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選25塊以下飲料
#10 // S0
in_coin = 6'd10 ;  // 投10
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選25塊以下飲料
#10 // S0
in_coin = 6'd1 ;  // 投1
#10 // S1
in_choose = 3'b000 ; // 沒選擇		  // output可選25塊以下飲料
#10 // S0
in_coin = 6'd0 ;     // 沒投錢
#10 // S3
reset = 1'b1 ;    // 退幣			  // output找零 47塊
#10 // S0
reset = 1'b0 ; 	  // 退幣訊號歸0      
// ------------------------- //

end
endmodule