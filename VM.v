module VM( coin, X, reset, clock, B_drink, r_Coin, O_drink,P_drink ) ;
  input [15:0] coin ;                    // 判斷是否有投錢
  input clock,reset ;
  reg [15:0] money ;                     // 儲存的錢
  input  X ;                              // 取消
  input  [5:0] B_drink ;             // 想買的飲料
  output reg [5:0] O_drink,P_drink ;             // 吐出的飲料  
  output reg [15:0] r_Coin ;

  
	 parameter S0 = 3'd0 ,                  // 投零錢 && 取消購買
            S1 = 3'd1 ,                  // 顯示可選擇飲料
            S2 = 3'd2 ,                  // 給飲料
            S3 = 3'd3 ;                  // 找零
  parameter A  = 6'd10 ,                 // 飲料A
            B  = 6'd15 ,                 // 飲料B
            C  = 6'd20 ,                 // 飲料C
            D  = 6'd25 ,                 // 飲料D
			O  = 6'd0  ;                 // 買不起喇   
			
  reg  enough, enoughMin ;                          // 是否足夠
  reg [2:0] state ;
  reg [2:0] next_state ;
  
  initial 
    begin
	  money = 0 ;
	  O_drink = 0 ;
	  P_drink = 0 ;
	  r_Coin = 0 ;
	  enough = 0 ;
	  state = S0 ;
	  next_state = S0 ;
	end
	
  always @( posedge clock )              // 改變狀態
    begin
      if ( reset )                       // 取消投的錢
	    state <= S3 ;
	  else 
	    state <= next_state ;
    end 
  
  always @ ( state or coin or money or B_drink ) 
    begin 
	  case ( state ) 
	    S0:                                       // 可以投錢
		  begin 
		    r_Coin = 0 ;                          // 找錢 設定為0
		    money = money + coin ;                // 我總共有多少錢
		  end
		S1:                                         
		   begin 
		    if ( money >= D ) P_drink = D ;      // 判斷錢夠買A嗎  輸出可以買的東西
		    else if ( money >= C ) P_drink = C ; // 判斷錢夠買B嗎
			else if ( money >= B ) P_drink = B ; // 判斷錢夠買C嗎
			else if ( money >= A ) P_drink = A ; // 判斷錢夠買D嗎      
            else  P_drink = O ;			       			
		   end 
		S2:
		   begin
		     if ( P_drink >= B_drink ) O_drink = P_drink ;
			 else  O_drink = 0 ;
		   end
		S3:
		   begin   
		     if ( O_drink != 0 )r_Coin = money - B_drink ;
			 else  r_Coin = money ;
             P_drink = 0 ;
             O_drink = 0 ;
             money = 0 ; 			 
		   end 
		endcase
	end 
	
	
  always @ ( state or enough or B_drink  or coin or enoughMin )
    begin
	  case ( state )
	    S0:
           begin 
		     if ( money > 16'd10 )    next_state = S1 ;
			 else             next_state = S0 ;
           end 		   
		S1:
		   begin 
		     if (  B_drink != 0 )  next_state = S2 ;   
			 else             next_state = S0 ;
		   end 
		S2:   next_state = S3 ;
		S3:   next_state = S0 ;
		default :
		  next_state = S0 ;
		endcase
    end	
endmodule  