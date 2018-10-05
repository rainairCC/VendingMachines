module TestBench() ;
  
  reg [15:0] coin ;                    // 判斷是否有投錢
  reg clock,reset ;
  reg X ;                              // 取消
  reg      [5:0] B_drink ;             // 想買的飲料
  wire [5:0] O_drink,P_drink ;             // 吐出的飲料  
  wire [15:0] r_Coin ;
  parameter A  = 6'd10 ,                 // 飲料A
            B  = 6'd15 ,                 // 飲料B
            C  = 6'd20 ,                 // 飲料C
            D  = 6'd25 ,                 // 飲料D
			O  = 6'd0  ;                 // 買不起喇   
  VM vm( coin, X, reset, clock, B_drink, r_Coin, O_drink,P_drink ) ;

 initial clock = 1 ;
 always #5 clock = ~clock ;
	
 initial
  begin
  X = 0 ;
 
  reset = 1'b0;
  B_drink = A ; 
  coin = 15'd0 ; 

// --case1---------- //  投15元  買A  找5
    #10 // S0
    coin = 15'd10 ; // 投10
	#10
	  coin = 15'd5 ;     // 沒投錢
   #10 // S1
    B_drink = A ; // 選A飲料  
    coin = 15'd0 ;     // 沒投錢
	#10 
    #10 // S2  // output給予A飲料
	
    #10 // S3  // output找零 5塊
	
    #30 // S0
    reset = 0 ;
// ------------------------- //


//  --case2----------  //  投1元  買A  買不起喇幹  找1 元
   #10 // S0
    coin = 15'd1 ; // 投10
   #10 // S1
    B_drink = A ; // 選A飲料  
    coin = 15'd0 ;     // 沒投錢
    #10 // S2  // output給予A飲料
	reset = 1 ;
    #10 // S3  // output找零 5塊
	 reset = 0 ;
    #30 // S0
	
	//
	//  --case3----------  //  投25元  買D    找0 元
	
   #10 // S0
    #10	
	  coin = 15'd10 ; // 投10
	#10	
	  coin = 15'd5 ; // 投10
	#10 
	   coin = 15'd10 ; // 投10
   #10 // S1
    B_drink = D ; // 選D飲料飲料  
    coin = 15'd0 ;     // 投5錢
    #10 // S2  // output給予A飲料
	
    #10 // S3  // output找零 5塊
	reset = 1 ;  // 找錢喇 
    #30 // S0
	
    reset = 0 ;
	//
	
	//  --case4----------  //  投26元 找錢 
   #10 // S0
     B_drink = 0 ; // 選A飲料  
     coin = 15'd10 ; // 投10
	
	  #10 // 
	   coin = 15'd1 ; // 投1
	  #10 // 
	   coin = 15'd5 ; // 投5
      #10 // 
	    coin = 15'd5 ; // 投5
      #10 // 
	    coin = 15'd5 ; // 投5
	  #10 
	  coin = 0 ;
	  reset = 1 ;  // 找錢喇 
    #30 // S0
	
    reset = 0 ;
	//
	
  end
endmodule   