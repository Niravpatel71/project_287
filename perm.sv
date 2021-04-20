module perm (input clk, input reset, input [2:0] dix, input [199:0] din, input pushin, output [2:0] doutix, output [199:0] dout, output pushout);

reg [4:0][4:0][63:0] perm_array_d,perm_array;//out_array_d,out_array;

reg [4:0][4:0][63:0] perm_0_d,perm_0;//,perm_1_d,perm_1;

//reg [4:0][4:0][63:0] temp_1,temp_2,temp_3,temp_4,temp_5,temp_1_1,temp_1_2,temp_1_3,temp_1_4,temp_1_5,temp_2_1,temp_2_2,temp_2_3,temp_2_4;	

reg [1599:0] temp_array,temp_array_d,out_temp_d,out_temp;

reg [6:0] in,in_d ; 

reg [2:0] dix_d ; 

reg [199:0] din_d,data_out_d,data_out;  

//reg perm_state,next_perm_state;//out_state,next_out_state;

reg vld1,busy_p_d,busy_p;

reg in_push_d,in_push,in0_push,in0_push_d;//,p_push0,p_push0_d,p_push1,p_push1_d,p_push2,p_push2_d,p_push3,p_push3_d,p_push4,p_push4_d;
reg p_push7_d,p_push7,out_push,out_push_d;// p_push5_d,p_push5,p_push6_d,p_push6
//reg [8:0]data_in_no_d,data_out_no_d,data_in_no,data_out_no;
reg [2:0] cnt_7,cnt_7_d,index_out,index_out_d,cnt_3,cnt_3_d;
//reg [3:0] cnt_3, cnt_3_d;

assign dout = data_out;
assign doutix =  index_out;
assign pushout = out_push;

always @(*) begin
	in0_push_d=in0_push;
	temp_array_d=temp_array;
	out_temp_d=out_temp;
	perm_0_d=perm_0;
	in_push_d=in_push;
	p_push7_d=p_push7;	out_push_d=out_push;
		if(vld1) begin
			case (dix_d)
		3'b000 :begin 
			temp_array_d[199:0]   =   din_d;
			in_d[0]	= vld1;
		end
		3'b001 :begin 
		       	temp_array_d[399:200] =  din_d;
			in_d[1]	= vld1;
		        end	
		3'b010 :begin
		       	temp_array_d[599:400] =  din_d;
			in_d[2]	=vld1;
		        end
		3'b011 :begin
		       	temp_array_d[799:600] =  din_d;
			in_d[3]	= vld1;
		        end
		3'b100 :begin
		       	temp_array_d[999:800] =  din_d;
			in_d[4]	=vld1;
		        end	
		3'b101 :begin 
		        temp_array_d[1199:1000] =  din_d;
			in_d[5]	=vld1;
		        end
		3'b110 :begin
		       	temp_array_d[1399:1200] =   din_d;
			in_d[6]	= vld1;
		        end	
		3'b111 :begin
		       	temp_array_d[1599:1400] =  din_d;
			in_d=0;
			in0_push_d=vld1;
//			data_in_no_d=data_in_no+1;
//			$write("\n");
//			$write("7 th data in =%h",din_d);
//			$write("\n");

		        end
	endcase
//	$write("in=%d  index_in= %d   data_in=%h",out_push,dix_d,din_d);
	end else begin
	temp_array_d = temp_array;
	end

	if (in0_push) begin
		in_push_d=in0_push;
		in0_push_d=!in0_push;
		perm_array_d=temp_array;//trying to add a buffer of the data
/*	$write ("\n i am 0 ") ; 	
	$write ("\n") ; 
		for(int i=0; i<5; i=i+1)begin
		for(int y=0; y<5;y=y+1)	begin
			$write("%h  ",perm_array_d[i][y]);
		end
		$write("\n");
	end 
*/
	end else begin
	    perm_array_d=perm_array;
	
	end

case(&cnt_3)
		1'b0: begin
			if (in_push) begin
				round3(perm_array,cnt_3,perm_0_d);
				in_push_d=1'b0;
			    //    next_perm_state=1'b1;
				cnt_3_d=cnt_3+1;
				busy_p_d=1;
			end else if (|cnt_3) begin
				round3(perm_0,cnt_3,perm_0_d);
				cnt_3_d=cnt_3+1;
			end else begin
				cnt_3_d=cnt_3;
				busy_p_d=1'b0;
				perm_0_d=0;
			end
		end
		1'b1: begin
		//	if (cnt_3 == 3'b111) begin
				round3(perm_0,cnt_3,perm_0_d);
				out_temp_d=perm_0_d;
				p_push7_d=1'b1;
				cnt_3_d=cnt_3+1;
			//	next_perm_state= 1'b0;

end

endcase

case(cnt_7)
		3'b000:begin
			if (p_push7) begin
				data_out_d=out_temp[199:0];
				index_out_d=cnt_7;
				out_push_d=1'b1;
				cnt_7_d=cnt_7+1;
				p_push7_d=~p_push7;
			end else begin
				cnt_7_d=cnt_7;
				out_push_d=0;
				data_out_d=0;
				index_out_d=0;
			end
		end
		3'b001:begin
			data_out_d=out_temp[399:200];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
		end
		3'b010:begin
			data_out_d=out_temp[599:400];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
		end
		3'b011:begin
			data_out_d=out_temp[799:600];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
		end
		3'b100:begin
			data_out_d=out_temp[999:800];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
			end
		3'b101:begin
			data_out_d=out_temp[1199:1000];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
		end
		3'b110:begin
			data_out_d=out_temp[1399:1200];
			index_out_d=cnt_7;
			//out_push_d=out_push;
			cnt_7_d=cnt_7+1;
		end
		3'b111:begin
			data_out_d=out_temp[1599:1400];
			index_out_d=cnt_7;
			cnt_7_d=cnt_7+1;
			//out_push_d=out_push;
//			data_out_no_d=data_out_no+1;
//			$write ("\n") ; 
//			$write("data_out_no=%d",data_out_no);
//			$write("\n");
		end
	endcase
//$write ("\n") ; 
//$write("out_push_d=%d  index_out= %d   data_out=%h",out_push_d,index_out_d,data_out_d);
end
always @ (posedge clk or posedge reset) begin
       if(reset) begin
		din_d<=0;
		dix_d<=0;
		vld1<=0;
		in <=0;
		cnt_3<=0;
		cnt_7<=0;
		temp_array<=0;
		out_temp<=0;
		perm_array<=0;
		perm_0<=0;
		in_push<=0;
		p_push7 <=0;
		busy_p <=0;
		out_push<=0;
		data_out<=0;
		index_out<=0;
//		perm_state<=0;
//		temp_1<=0;   temp_2<=0;   temp_3<=0;   temp_4<=0;   temp_5<=0; 
//		temp_1_1<=0; temp_1_2<=0; temp_1_3<=0; temp_1_4<=0;temp_1_5<=0;
//		temp_2_1<=0; temp_2_2<=0; temp_2_3<=0; temp_2_4<=0;
//		data_in_no<=0;
//		data_out_no<=0;
	end else begin
		din_d<= #1 din;
 		dix_d<= #1 dix;
 		vld1<= #1 pushin;
		in <= #1 in_d;
		cnt_3 <= #1 cnt_3_d;
		cnt_7 <= #1 cnt_7_d;
		temp_array<= #1 temp_array_d;
		out_temp<= #1 out_temp_d;
		perm_array<= #1 perm_array_d; 
		perm_0<= #1 perm_0_d;
		in_push <= #1 in_push_d;
		in0_push<= #1 in0_push_d;
		p_push7<= #1 p_push7_d;
		busy_p <= #1 busy_p_d; 
//		data_in_no <= #1 data_in_no_d;
//		data_out_no<=#1 data_out_no_d;
		out_push<= #1 out_push_d;
		data_out<= #1 data_out_d;
		index_out<=#1 index_out_d;
//		perm_state <= #1 next_perm_state;
	end	

end

/*******************************************called Function code************/
/*********1 round thing*****/ 

function void round3 (input reg [4:0][4:0][63:0] a, input reg [3:0] c, output reg [4:0][4:0][63:0] b);

reg [4:0][4:0][63:0] temp_1,temp_2,temp_3,temp_4,temp_5,temp_1_1,temp_1_2,temp_1_3,temp_1_4,temp_1_5,temp_2_1,temp_2_2,temp_2_3,temp_2_4;	

	
/*
	temp_1=0; temp_2=0; temp_3=0; temp_4=0; temp_5=0; 
	temp_1_1=0; temp_1_2=0; temp_1_3=0;temp_1_4=0;temp_1_5=0;
	temp_2_1=0;temp_2_2=0;temp_2_3=0;temp_2_4=0;	 
*/      
       theta(a,temp_1);
       rho(temp_1,temp_2);
       pi(temp_2,temp_3);
       zai(temp_3,temp_4);
       yota(temp_4,c*3,temp_5);
       //1 permutation
       theta(temp_5,temp_1_1);
       rho(temp_1_1,temp_1_2);
       pi(temp_1_2,temp_1_3);
       zai(temp_1_3,temp_1_4);
       yota(temp_1_4,c*3+1,temp_1_5);
       //2 permutation
       theta(temp_1_5,temp_2_1);
       rho(temp_2_1,temp_2_2);
       pi(temp_2_2,temp_2_3);
       zai(temp_2_3,temp_2_4);
       yota(temp_2_4,c*3+2,b);
      //End of 1 round
/*      $write("end of round =%d",c*3+2);
      $write("\n");
  for(int i=0; i<5; i=i+1)begin
		for(int y=0; y<5;y=y+1)	begin
			$write("%h  ",b[i][y]);
		end
		$write("\n");
	end 
*/
endfunction
/*********** Moululus Function = mlo******/
function integer mlo (input integer x, input integer y); 
  if(x%y < 0) mlo= x%y+y;
 else mlo= x%y ;
endfunction 

/****************theta function*********/
function void theta (input reg [4:0][4:0][63:0] a, output reg [4:0][4:0][63:0] b );
  reg  [4:0][63:0] c, d;
  int i,f ;//i and f is for secction of row and bit 
  int x, y;
  int p,q,r; 
  for (i=0; i<=4; i=i+1) begin   // build c[x][z]
	  for(f=0;f<=63; f=f+1) begin
		  c[i][f] = a[0][i][f] ^ a[1][i][f] ^ a[2][i][f] ^ a[3][i][f] ^ a[4][i][f];
	  end
  end
  for ( x =0;x<=4;x=x+1) begin // build d[x][z]
	  for (y=0;y <=64; y=y+1) begin
		  d[x][y]= c[mlo((x-1),5)][y] ^ c[mlo((x+1),5)][mlo((y-1),64)];
		end 
  end
  for(p=0;p<=4;p=p+1) begin
	  for (q=0;q<=4;q=q+1)begin
		  for (r=0;r<=63;r=r+1)begin
			b[p][q][r] = a[p][q][r]^ d[q][r];
		  end
	  end
  end
endfunction

/********************** rho **************/
function void rho (input reg [4:0][4:0][63:0] a, output reg [4:0][4:0][63:0] b);
	int t,z,x,y,p,q,u;
	for (u=0;u<=63;u=u+1) b[0][0][u]=a[0][0][u];
	x=1;
	y=0;
	for (t=0;t<=23;t=t+1) begin
	  	for(z=0;z<=63;z=z+1) begin
		b[y][x][z] = a[y][x][mlo((z-(t+1)*(t+2)/2),64)];
	 	end
		p=x;
		q=y;
		x=q;
		y=mlo((2*p+3*q),5);
	end
endfunction 
/******************pi***************/
function void pi(input reg [4:0][4:0][63:0] a, output reg [4:0][4:0][63:0] b);
	int p,q,r;
	for (p=0;p<=4;p=p+1) begin
		for (q=0;q<=4;q=q+1)begin
			for (r=0;r<=63;r=r+1)begin
			b[q][p][r]= a[p][mlo((p+(3*q)),5)][r];
			end
		end
	end
endfunction
/*************************zai******/
function void zai (input reg [4:0][4:0][63:0]a, output reg [4:0][4:0][63:0] b);
	int p,q,r;
		for (p=0;p<=4;p=p+1) begin
			for (q=0;q<=4;q=q+1)begin
				for (r=0;r<=63;r=r+1)begin
				b[q][p][r]= a [q][p][r]^((a[q][mlo((p+1),5)][r]^1) & a[q][mlo((p+2),5)][r]);
				end
			end
		end
endfunction
/*****yota*****if Not sure about the RC constants use back up Hard coded yota **
function void yota(input reg [4:0][4:0][63:0]a, input reg [5:0] ir, output reg [4:0][4:0][63:0] b);// ir is no of round= 0to 24 
	int r,j,p,q,z;
	reg [63:0]rc; 
	for (p=0;p<=4;p=p+1) begin
			for (q=0;q<=4;q=q+1)begin
				for (r=0;r<=63;r=r+1)begin
					b[p][q][r]=a[p][q][r];
				end
			end
		end
	rc = 0;
	for(j=0;j<=6;j=j+1) begin
		rc [(2**j)-1] = rc_func(j + 7*ir); // rc_func call 
	end
	for(z=0;z<=63;z=z+1)begin
		b[0][0][z] = a[0][0][z]^rc[z];
	end
endfunction

*******rc******it is a part of yota and alog 5 is rc*****
function reg  rc_func  (input int t);
	reg [8:0] r;
	int i;
	if (mlo(t,225) == 0) begin 
		return 1'b1;
	end else begin 
		r=8'b10000000;
		for (i=1;i<= mlo(t,225);i=i+1)
		begin 
		r={1'b0,r};
		r[8]=r[8]^r[0];
		r[4]=r[4]^r[0];
		r[3]=r[3]^r[0];
		r[2]=r[2]^r[0];
		r=r[8:1];
		return r[8];
	end
end
endfunction
********DO NOT REMOVE****************Hard coded rc valus yota******/
function void yota(input reg [4:0][4:0][63:0]a, input reg [5:0] ir, output reg [4:0][4:0][63:0] b);
	int p,q,r,z;
	reg [63:0]rc; 
	rc=64'b0;
	for (p=0;p<=4;p=p+1) begin
			for (q=0;q<=4;q=q+1)begin
				for (r=0;r<=63;r=r+1)begin
					b[p][q][r]=a[p][q][r];
				end
			end
		end
	case(ir)
		0: rc=64'h0000000000000001;
		1: rc=64'h0000000000008082;
		2: rc=64'h800000000000808A;
		3: rc=64'h8000000080008000;
		4: rc=64'h000000000000808B;
		5: rc=64'h0000000080000001;
		6: rc=64'h8000000080008081;
		7: rc=64'h8000000000008009;
		8: rc=64'h000000000000008A;
		9: rc=64'h0000000000000088;
		10: rc=64'h0000000080008009;
		11: rc=64'h000000008000000A;
		12: rc=64'h000000008000808B;
		13: rc=64'h800000000000008B;
		14: rc=64'h8000000000008089;
		15: rc=64'h8000000000008003;
		16: rc=64'h8000000000008002;
		17: rc=64'h8000000000000080;
		18: rc=64'h000000000000800A;
		19: rc=64'h800000008000000A;
		20: rc=64'h8000000080008081;
		21: rc=64'h8000000000008080;
		22: rc=64'h0000000080000001;
		23: rc=64'h8000000080008008;
	default :rc=64'h0000000000000000;//  Not sure, kept to avoide latch 
	endcase
	for(z=0;z<=63;z=z+1)begin
		b[0][0][z]=a[0][0][z]^rc[z];
	end
endfunction
/*************************************************The end****/

endmodule

