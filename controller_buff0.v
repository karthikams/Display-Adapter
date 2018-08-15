module controller_buff0(RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1, SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1, row0, row1,
			PxOut, LineOut, VBOut, AIPOut, AILOut, CSDisplay, clock, reset);


output reg RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1, SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1;
input [3:0] VBOut, AILOut, AIPOut, PxOut, LineOut;
input [6:0] row0, row1;
input clock, reset, CSDisplay;
reg[8:0] counter;

parameter zero = 9'b0;
integer rgb_count = 0 ;
integer buf_select = 0;


initial 
begin
  counter = 9'b111111111;
  RE0 = 0;
  RE1 = 0;
  ResetAddr1 = 0;
  ResetAddr0 = 0; 
end

always@(posedge clock or posedge reset)
begin

	if(reset) counter <= 9'b111111111;

	if(CSDisplay)
	begin
  
	   counter = counter + 9'b01;
	   rgb_count = counter%3;
	  
	  // If counter value is zero and buf_select is even the 
	  // initial state of Buf0 is activated.
	  if((counter == zero) && (buf_select%2 == 0))                     
	  begin
		 
		 SelBlank <= 1'b1;
  		 Buf1Empty <= 1'b1;
		 Buf0Empty <= 1'b0;
  		 SyncVB <= 1'b1;
		 RE0 <= 1'b0;
		 RE1 <= 1'b0;
		 SelB1 <= 1'b0;
		 WE0 <= 1'b1;
	  end

	  // If counter value is zero and buf_select is odd the 
	  // initial state of Buf1 is activated.
	  else if((counter == zero) && (buf_select%2 == 1) )              
	  begin
		
		 SelBlank <= 1'b1;
  		 Buf0Empty <= 1'b1;
		 Buf1Empty <= 1'b0;
  		 SyncVB <= 1'b1;
		 RE0 <= 1'b0;
		 RE1 <= 1'b0;
		 SelB0 <= 1'b0; 
	  end

	  //SyncVB is made 0 after the first cycle.
	  else if(counter == 1)						
	  begin
	  	SyncVB <= 1'b0;
  	  end
	
	//If RE0 is high then the active image of Buf0 is read
	if(RE0)
	begin
		SelBlank <= 0;
		SelBuf0 <= 1;

		//Condition to check if it is not last pixel		
		if(PxOut < AIPOut - 1)
	  	begin

			//Validation for Red Pixel	  		
			if(rgb_count == 0)			
			begin
				SelR0 <= 1;
				SelB0 <= 0;
				SelG0 <= 0;
				SelBuf0 <= 1;
				RE0 <= 1;
				IncPx <=0;
				IncAddr0 <= 0;
			end

			//Validation for Green Pixel
			else if(rgb_count == 1)			
			begin
				SelG0 <= 1;
				SelB0 <= 0;
				SelR0 <= 0;
				SelBuf0 <= 1;
				RE0 <= 1;
				IncAddr0 <= 1;
				IncPx <=0;
			end

			//Validation for Blue Pixel
			else if(rgb_count == 2)			
			begin
				SelB0 <= 1;
				SelR0 <= 0;
				SelG0 <= 0;
				SelBuf0 <= 1;
				RE0 <= 1;
				IncPx <=1;
				IncAddr0 <= 0;
			end
	 	end

		//Condition to check if it is last pixel
		else if(PxOut == AIPOut - 1)			
		begin
			//Validation for Last Red Pixel
			if(rgb_count == 0)			
			begin
				SelR0 <= 1;
				SelB0 <= 0;
				SelG0 <= 0;
				SelBuf0 <= 1;
				RE0 <= 1;
				IncPx <= 0;
				ResetPx <= 0;
				IncLine <= 0;
				ResetLine <= 0;
				IncAddr0 <= 0;
			end

			//Validation for Last Green Pixel
			else if(rgb_count == 1)			
			begin
				SelG0 <= 1;
				SelB0 <= 0;
				SelR0 <= 0;
				SelBuf0 <= 1;
				IncPx <= 0;
				ResetPx <= 0;
				IncLine <= 0;
				ResetLine <= 0;
				RE0 <= 1;
				IncAddr0 <= 1;

				//Check for Last Line
				if(LineOut == AILOut - 1)	
				begin
					ResetAddr0 <=1;
				end
			end

			//Validation for Last Blue Pixel
			else if(rgb_count == 2)			
			begin
				ResetPx <= 1;
				IncPx <= 0;
				SelB0 <= 1;
				SelR0 <= 0;
				SelG0 <= 0;
				SelBuf0 <= 1;
				IncAddr0 <= 0;

				//Condition to check if it is not last line	
				if(LineOut < AILOut - 1)	
				begin
					IncLine <= 1;
					SelBlank <= 0;
					ResetLine <= 0;
				end

				//condition to check if it is last line
				else if(LineOut == AILOut - 1)				
				begin
					ResetLine <= 1;
					ResetAddr0 <= 0;
					counter <= 9'b111111111;			//resetting the counter in the last active blue pixel and last line
					buf_select <= buf_select + 1;                    //Changing to the next buffer
					RE0 <= 1'b0;
					
				end
			end
		end    

	end //if(RE0)


	//If RE1 is high then the active image of Buf1 is read
	else if(RE1)
	begin
		SelBlank <= 0;
		SelBuf1 <= 1;
	
		// Condition to check if it is not last pixel
		if(PxOut < AIPOut - 1)
	  	begin
			//Validation for Red Pixel
	  		if(rgb_count == 0)			
			begin
				SelR1 <= 1;
				SelB1 <= 0;
				SelG1 <= 0;
				SelBuf1 <= 1;
				RE1 <= 1;
				IncPx <=0;
				IncAddr1 <= 0;
			end

			//Validation for green Pixel
			else if(rgb_count == 1)			
			begin
				SelG1 <= 1;
				SelB1 <= 0;
				SelR1 <= 0;
				SelBuf1 <= 1;
				RE1 <= 1;
				IncAddr1 <= 1;
				IncPx <=0;
			end

			//Validation for Blue Pixel
			else if(rgb_count == 2)			
			begin
				SelB1 <= 1;
				SelR1 <= 0;
				SelG1 <= 0;
				SelBuf1 <= 1;
				RE1 <= 1;
				IncPx <=1;
				IncAddr1 <= 0;
			end
	 	end

		//Condition to check if it is last pixel
		else if(PxOut == AIPOut - 1)			
		begin
			//Validation for LastRed Pixel
			if(rgb_count == 0)			
			begin
				SelR1 <= 1;
				SelB1 <= 0;
				SelG1 <= 0;
				SelBuf1 <= 1;
				RE1 <= 1;
				IncPx <= 0;
				ResetPx <= 0;
				IncLine <= 0;
				ResetLine <= 0;
				IncAddr1 <= 0;
			end

			//Validation for Last Green Pixel
			else if(rgb_count == 1)			
			begin
				SelG1 <= 1;
				SelB1 <= 0;
				SelR1 <= 0;
				SelBuf1 <= 1;
				IncPx <= 0;
				ResetPx <= 0;
				IncLine <= 0;
				ResetLine <= 0;
				RE1 <= 1;
				IncAddr1 <= 1;

				//Check if Last Line
				if(LineOut == AILOut - 1)	
				begin
					ResetAddr1 <=1;
				end
			end

			//Validation for Last Blue Pixel
			else if(rgb_count == 2)			
			begin
				ResetPx <= 1;
				IncPx <= 0;
				SelB1 <= 1;
				SelR1 <= 0;
				SelG1 <= 0;
				SelBuf1 <= 1;
				IncAddr1 <= 0;

				//Condition to check if it is not last line	
				if(LineOut < AILOut - 1)	
				begin
					IncLine <= 1;
					SelBlank <= 0;
					ResetLine <= 0;
				end

				//Condition to check if it is last line	
				else if(LineOut == AILOut - 1)				
				begin
					ResetLine <= 1;
					ResetAddr1 <= 0; 
					counter <= 9'b111111111;			//resetting the counter in the last active blue pixel and last line
					buf_select <= buf_select + 1;                     //Changing to the next buffer
					RE1 <= 1'b0;
				end
			end
		end   

	end//if(RE1)

	//If neither RE0 nor RE1 it is blanking region
	else 
	begin
	SelBuf1 <= 0;
	SelBuf0 <= 0;
	//For every blue pixel it is checked if it is last pixel or not
	if(rgb_count == 2)
		begin
			//Verifying if it is not Last Pixel 
			if(PxOut < AIPOut - 1)       				
			begin
				IncPx <=1;
				SelBlank <= 1;
			end

			//Verifying If it is Last Pixel
			else if(PxOut == AIPOut -1)			    
			begin
			
				 //Verifying if it is Last Line of blanking region 	
				if(LineOut < VBOut - 1)			 
				begin
					ResetPx <= 1;
					IncPx <= 0;
					IncLine <= 1;
					SelBlank <=1;
				end
				else if(LineOut == VBOut -1)				 
				begin
					ResetPx <=1 ;
					ResetLine <= 1;
					IncLine <= 0;
					IncPx <= 0;
					if(buf_select%2 == 0) RE0 <= 1;			// RE0 is set to high
					else if(buf_select%2 == 1) RE1 <= 1;		//RE1 is set to high
					
				end
			end
		end
	else
	begin
		IncPx <= 0;
		ResetPx <= 0;
		ResetLine <= 0;
		IncLine <= 0;
	end
	end //Blanking region
	
	end//CSdisplay
end//always

// To make WE0 low  and WE1 high after all rows of Buf0 are filled
// WE1 is made low after all rows of Buf1 are filled  
always@(clock or posedge reset)
begin
	if(CSDisplay)
	begin
		
		if(row0 == 7'b1100011) 
		begin	
			WE0 <= 1'b0;
			WE1 <= 1'b1;
		end

		if(row1 == 7'b1100011)
		begin
 			WE1 <= 1'b0;
		end

	end
end

endmodule
