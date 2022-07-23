----------------------------------------------------------------------------------
-- OV7670 -- FPGA -- VGA -- Monitor
-- The 1st revision
-- Revision : 
	-- Adjustment several entities so they can fit with the top module.
	-- Generate single clock modificator.
-- Credit:
	-- Thanks to Mike Field for Registers Reference
-- Your design might has diffent pin assignment.
-- Discuss with me by email : Jason Danny Setiawan [jasondannysetiawan@gmail.com]
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
	Port	(	clk50	: in STD_LOGIC; -- Crystal Oscilator 50MHz  --B8
	clkcam	: in STD_LOGIC; -- Crystal Oscilator 23.9616 MHz  --U9
				pb		: in STD_LOGIC; -- Push Button --B18
				sw		: in STD_LOGIC; -- Push Button --G18
				led1 : out STD_LOGIC; -- Indicates configuration has been done --J14
				led2 : out STD_LOGIC; -- Indicates configuration has been done --J14
				led3 : out STD_LOGIC; -- Indicates configuration has been done --J14
				led4 : out STD_LOGIC; -- Indicates configuration has been done --J14
			  anode : out std_logic_vector(3 downto 0);
				-- OV7670
				ov7670_pclk1,ov7670_pclk2,ov7670_pclk3,ov7670_pclk4  : in  STD_LOGIC; -- Pmod JB8 --R16
				ov7670_xclk1,ov7670_xclk2,ov7670_xclk3,ov7670_xclk4  : out STD_LOGIC; -- Pmod JB2 --R18
				ov7670_vsync1,ov7670_vsync2,ov7670_vsync3,ov7670_vsync4 : in  STD_LOGIC; -- Pmod JB9 --T18
				ov7670_href1,ov7670_href2,ov7670_href3,ov7670_href4  : in  STD_LOGIC; -- Pmod JB3 --R15
				ov7670_data1,ov7670_data2,ov7670_data3,ov7670_data4  : in  STD_LOGIC_vector(7 downto 0);
									-- D0 : Pmod JA2 --K12 			-- D4 : Pmod JA4  --M15
									-- D1 : Pmod JA8 --L16			-- D5 : Pmod JA10 --M16
									-- D2 : Pmod JA3 --L17			-- D6 : Pmod JB1  --M13
									-- D3 : Pmod JA9 --M14			-- D7 : Pmod JB7  --P17
				ov7670_sioc1,ov7670_sioc2,ov7670_sioc3,ov7670_sioc4  : out STD_LOGIC; -- Pmod JB10 --J12
				ov7670_siod1,ov7670_siod2,ov7670_siod3,ov7670_siod4  : inout STD_LOGIC; -- Pmod JB4 --H16
				ov7670_pwdn1,ov7670_pwdn2,ov7670_pwdn3,ov7670_pwdn4  : out STD_LOGIC; -- Pmod JA1 --L15
				ov7670_reset1,ov7670_reset2,ov7670_reset3,ov7670_reset4 : out STD_LOGIC; -- Pmod JA7 --K13
				
				--VGA
				vga_hsync : out STD_LOGIC; --T4
				vga_vsync : out STD_LOGIC; --U3
				vga_rgb	: out STD_LOGIC_VECTOR(7 downto 0)
				-- R : R9(MSB), T8, R8
				-- G : N8, P8, P6
				-- Bc: U5, U4(LSB) 
			 );
end Top;

architecture Structural of Top is

COMPONENT debounce_circuit
	Port ( clk : in STD_LOGIC;
			 input : in STD_LOGIC;
			 output : out STD_LOGIC);
END COMPONENT;

COMPONENT clk25gen
	Port ( clk50 : in  STD_LOGIC;
          clk25 : out  STD_LOGIC);
END COMPONENT;

COMPONENT ov7670_capture
	Port ( pclk : in  STD_LOGIC;
          vsync : in  STD_LOGIC;
          href : in  STD_LOGIC;
          d : in  STD_LOGIC_VECTOR (7 downto 0);
          addr : out  STD_LOGIC_VECTOR (14 downto 0);
          dout : out  STD_LOGIC_VECTOR (2 downto 0);
          we : out  STD_LOGIC_VECTOR (0 downto 0));
END COMPONENT;

COMPONENT ov7670_controller
	Port ( clk : in  STD_LOGIC;
          resend : in  STD_LOGIC;
          sioc : out  STD_LOGIC;
          siod : inout  STD_LOGIC;
          conf_done : out  STD_LOGIC;
          pwdn : out  STD_LOGIC;
			 reset: out  STD_LOGIC;
			 xclk_in : in  STD_LOGIC;
          xclk_out: out  STD_LOGIC);
END COMPONENT;

COMPONENT frame_buffer
	Port ( clkA : in STD_LOGIC;
			 weA	: in STD_LOGIC_VECTOR(0 downto 0);
			 addrA: in STD_LOGIC_VECTOR(14 downto 0);
			 dinA	: in STD_LOGIC_VECTOR(2 downto 0);
			 clkB : in STD_LOGIC;
			 addrB: in STD_LOGIC_VECTOR(14 downto 0);
			 doutB: out STD_LOGIC_VECTOR(2 downto 0));
END COMPONENT;

COMPONENT vga_imagegenerator
	Port ( Data_in1 : in  STD_LOGIC_VECTOR (2 downto 0);
						Data_in2 : in  STD_LOGIC_VECTOR (2 downto 0);
						Data_in3 : in  STD_LOGIC_VECTOR (2 downto 0);
						Data_in4 : in  STD_LOGIC_VECTOR (2 downto 0);
						active_area1 : in  STD_LOGIC;
						active_area2 : in  STD_LOGIC;
						active_area3 : in  STD_LOGIC;
						active_area4 : in  STD_LOGIC;
           RGB_out : out  STD_LOGIC_VECTOR (7 downto 0));
END COMPONENT;

COMPONENT address_generator
	Port ( clk25 : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 vsync : in STD_LOGIC;
			 address : out STD_LOGIC_VECTOR (14 downto 0));
END COMPONENT;

COMPONENT VGA_timing_synch
	Port ( clk25 : in  STD_LOGIC;
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           activeArea1 : out  STD_LOGIC;
           activeArea2 : out  STD_LOGIC;
           activeArea3 : out  STD_LOGIC;
           activeArea4 : out  STD_LOGIC);
END COMPONENT;

signal clk25 : STD_LOGIC;
signal resend : STD_LOGIC;

-- RAM
signal wren1,wren2,wren3,wren4 : STD_LOGIC_VECTOR(0 downto 0);
signal wr_d1,wr_d2,wr_d3,wr_d4 : STD_LOGIC_VECTOR(2 downto 0);
signal wr_a1,wr_a2,wr_a3,wr_a4 : STD_LOGIC_VECTOR(14 downto 0);
signal rd_d1,rd_d2,rd_d3,rd_d4 : STD_LOGIC_VECTOR(2 downto 0);
signal rd_a1,rd_a2,rd_a3,rd_a4 : STD_LOGIC_VECTOR(14 downto 0);

--VGA
signal active1,active2,active3,active4 : STD_LOGIC;
signal vga_vsync_sig : STD_LOGIC;

signal cc : std_logic;

begin
	anode <= "0111";

	inst_clk25: clk25gen port map(
		clk50 => clk50,
		clk25 => clk25);
	
	inst_debounce: debounce_circuit port map(
		clk => clk50,
		input => pb,
		output => resend);
	
	inst_ov7670contr1: ov7670_controller port map(
		clk => clk50,
		resend => resend,
		sioc => ov7670_sioc1,
		siod => ov7670_siod1,
		conf_done => led1,
		pwdn => ov7670_pwdn1,
		reset => ov7670_reset1,
		xclk_in => cc,
		xclk_out => ov7670_xclk1);
	inst_ov7670contr2: ov7670_controller port map(
		clk => clk50,
		resend => resend,
		sioc => ov7670_sioc2,
		siod => ov7670_siod2,
		conf_done => led2,
		pwdn => ov7670_pwdn2,
		reset => ov7670_reset2,
		xclk_in => cc,
		xclk_out => ov7670_xclk2);
	inst_ov7670contr3: ov7670_controller port map(
		clk => clk50,
		resend => resend,
		sioc => ov7670_sioc3,
		siod => ov7670_siod3,
		conf_done => led3,
		pwdn => ov7670_pwdn3,
		reset => ov7670_reset3,
		xclk_in => cc,
		xclk_out => ov7670_xclk3);
	inst_ov7670contr4: ov7670_controller port map(
		clk => clk50,
		resend => resend,
		sioc => ov7670_sioc4,
		siod => ov7670_siod4,
		conf_done => led4,
		pwdn => ov7670_pwdn4,
		reset => ov7670_reset4,
		xclk_in => cc,
		xclk_out => ov7670_xclk4);
	
	inst_ov7670capt1: ov7670_capture port map(
		pclk => ov7670_pclk1,
		vsync => ov7670_vsync1,
		href => ov7670_href1,
		d => ov7670_data1,
		addr => wr_a1,
		dout => wr_d1,
		we => wren1);
	inst_ov7670capt2: ov7670_capture port map(
		pclk => ov7670_pclk2,
		vsync => ov7670_vsync2,
		href => ov7670_href2,
		d => ov7670_data2,
		addr => wr_a2,
		dout => wr_d2,
		we => wren2);
	inst_ov7670capt3: ov7670_capture port map(
		pclk => ov7670_pclk3,
		vsync => ov7670_vsync3,
		href => ov7670_href3,
		d => ov7670_data3,
		addr => wr_a3,
		dout => wr_d3,
		we => wren3);
	inst_ov7670capt4: ov7670_capture port map(
		pclk => ov7670_pclk4,
		vsync => ov7670_vsync4,
		href => ov7670_href4,
		d => ov7670_data4,
		addr => wr_a4,
		dout => wr_d4,
		we => wren4);
	
	inst_framebuffer1 : frame_buffer port map(
		weA => wren1,
		clkA => ov7670_pclk1,
		addrA => wr_a1,
		dinA => wr_d1,
		clkB => clk25,
		addrB => rd_a1,
		doutB => rd_d1);
	inst_framebuffer2 : frame_buffer port map(
		weA => wren2,
		clkA => ov7670_pclk2,
		addrA => wr_a2,
		dinA => wr_d2,
		clkB => clk25,
		addrB => rd_a2,
		doutB => rd_d2);
	inst_framebuffer3 : frame_buffer port map(
		weA => wren3,
		clkA => ov7670_pclk3,
		addrA => wr_a3,
		dinA => wr_d3,
		clkB => clk25,
		addrB => rd_a3,
		doutB => rd_d3);
	inst_framebuffer4 : frame_buffer port map(
		weA => wren4,
		clkA => ov7670_pclk4,
		addrA => wr_a4,
		dinA => wr_d4,
		clkB => clk25,
		addrB => rd_a4,
		doutB => rd_d4);
	
	inst_addrgen1 : address_generator port map(
		clk25 => clk25,
		enable => active1,
		vsync => vga_vsync_sig,
		address => rd_a1);
	inst_addrgen2 : address_generator port map(
		clk25 => clk25,
		enable => active2,
		vsync => vga_vsync_sig,
		address => rd_a2);
	inst_addrgen3 : address_generator port map(
		clk25 => clk25,
		enable => active3,
		vsync => vga_vsync_sig,
		address => rd_a3);
	inst_addrgen4 : address_generator port map(
		clk25 => clk25,
		enable => active4,
		vsync => vga_vsync_sig,
		address => rd_a4);

	inst_imagegen : vga_imagegenerator port map(
		Data_in1 => rd_d1,
		Data_in2 => rd_d2,
		Data_in3 => rd_d3,
		Data_in4 => rd_d4,
		active_area1 => active1,
		active_area2 => active2,
		active_area3 => active3,
		active_area4 => active4,
		RGB_out => vga_rgb);
	
	inst_vgatiming : VGA_timing_synch port map(
		clk25 => clk25,
		Hsync => vga_hsync,
		Vsync => vga_vsync_sig,
		activeArea1 => active1,
		activeArea2 => active2,
		activeArea3 => active3,
		activeArea4 => active4);

vga_vsync <= vga_vsync_sig;

cc <= clkcam when sw = '1' else clk25;
end Structural;

