---------------------------------------------------------------
-- This entity prepare the color of a pixel which will be sent
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_imagegenerator is
<<<<<<<< HEAD:new_init_qqvga_st7735/vga_imagegenerator.vhd
    Port (	reset : in std_logic; clk : std_logic; Data_in1 : in  STD_LOGIC_VECTOR (11 downto 0);
						Data_in2 : in  STD_LOGIC_VECTOR (11 downto 0);
						Data_in3 : in  STD_LOGIC_VECTOR (11 downto 0);
						Data_in4 : in  STD_LOGIC_VECTOR (11 downto 0);
						active_area1 : in  STD_LOGIC;
						active_area2 : in  STD_LOGIC;
						active_area3 : in  STD_LOGIC;
========
    Port (	reset : in std_logic; clk : std_logic; Data_in1 : in  STD_LOGIC_VECTOR (4 downto 0);
						Data_in2 : in  STD_LOGIC_VECTOR (4 downto 0);
						Data_in3 : in  STD_LOGIC_VECTOR (4 downto 0);
						Data_in4 : in  STD_LOGIC_VECTOR (4 downto 0);
						active_area1 : in  STD_LOGIC;
						active_area2 : in  STD_LOGIC;
						active_area3 : in  STD_LOGIC;
>>>>>>>> r1/new_init_qvga:new_init_qvga/vga_imagegenerator.vhd
						active_area4 : in  STD_LOGIC;
           RGB_out : out  STD_LOGIC_VECTOR (7 downto 0));
end vga_imagegenerator;

architecture Behavioral of vga_imagegenerator is
--signal d1,d2,d3,d4 : std_logic_vector(7 downto 0);
begin
	-- Red : 11 downto 8
	-- Green : 7 downto 4
	-- Blue : 3 downto 0
	-- Nexys2 D/A converter supports 3 bits red, 3 bits green, and 2 bits blue. 
<<<<<<<< HEAD:new_init_qqvga_st7735/vga_imagegenerator.vhd
	RGB_out <= Data_in1(11 downto 9) & Data_in1(7 downto 5) & Data_in1(3 downto 2) when active_area1 = '1' else (others=>'0');
--	RGB_out <= Data_in1 when active_area1 = '1' else (others=>'0');

--process (clk,reset) is
--begin
--if (reset = '1') then
--d1 <= (others => '0');
--d2 <= (others => '0');
--d3 <= (others => '0');
--d4 <= (others => '0');
--elsif (falling_edge(clk)) then
----d1 <= Data_in1(2)&"00" & Data_in1(1)&"00" & Data_in1(0)&"0";
----d2 <= Data_in2(2)&"00" & Data_in2(1)&"00" & Data_in2(0)&"0";
----d3 <= Data_in3(2)&"00" & Data_in3(1)&"00" & Data_in3(0)&"0";
----d4 <= Data_in4(2)&"00" & Data_in4(1)&"00" & Data_in4(0)&"0";
--d1 <= Data_in1(0)&"00" & Data_in1(0)&"00" & Data_in1(0)&"0";
--d2 <= Data_in2(0)&"00" & Data_in2(0)&"00" & Data_in2(0)&"0";
--d3 <= Data_in3(0)&"00" & Data_in3(0)&"00" & Data_in3(0)&"0";
--d4 <= Data_in4(0)&"00" & Data_in4(0)&"00" & Data_in4(0)&"0";
--end if;
--end process;
--
--process (clk,reset) is
--begin
--if (reset = '1') then
--RGB_out <= (others => '0');
--elsif rising_edge(clk) then
--if(active_area1 = '1') then
--RGB_out <= d1;
--elsif(active_area2 = '1') then
--RGB_out <= d2;
--elsif(active_area3 = '1') then
--RGB_out <= d3;
--elsif(active_area4 = '1') then
--RGB_out <= d4;
--else
--RGB_out <= (others => '0');
--end if;
--end if;
--end process;

--RGB_out <=
--d1 when active_area1 = '1' else
--d2 when active_area2 = '1' else
--d3 when active_area3 = '1' else
--d4 when active_area4 = '1' else
--"00000000";

end Behavioral;

========
--	RGB_out <= Data_in(11 downto 9) & Data_in(7 downto 5) & Data_in(3 downto 2) when active_area = '1' else (others=>'0');
	RGB_out <= Data_in1(4 downto 3)&"0" & Data_in1(2 downto 1)&"0" & Data_in1(0)&"0" when active_area1 = '1' else (others=>'0');

--process (clk,reset) is
--begin
--if (reset = '1') then
--d1 <= (others => '0');
--d2 <= (others => '0');
--d3 <= (others => '0');
--d4 <= (others => '0');
--elsif (falling_edge(clk)) then
----d1 <= Data_in1(2)&"00" & Data_in1(1)&"00" & Data_in1(0)&"0";
----d2 <= Data_in2(2)&"00" & Data_in2(1)&"00" & Data_in2(0)&"0";
----d3 <= Data_in3(2)&"00" & Data_in3(1)&"00" & Data_in3(0)&"0";
----d4 <= Data_in4(2)&"00" & Data_in4(1)&"00" & Data_in4(0)&"0";
--d1 <= Data_in1(0)&"00" & Data_in1(0)&"00" & Data_in1(0)&"0";
--d2 <= Data_in2(0)&"00" & Data_in2(0)&"00" & Data_in2(0)&"0";
--d3 <= Data_in3(0)&"00" & Data_in3(0)&"00" & Data_in3(0)&"0";
--d4 <= Data_in4(0)&"00" & Data_in4(0)&"00" & Data_in4(0)&"0";
--end if;
--end process;
--
--process (clk,reset) is
--begin
--if (reset = '1') then
--RGB_out <= (others => '0');
--elsif rising_edge(clk) then
--if(active_area1 = '1') then
--RGB_out <= d1;
--elsif(active_area2 = '1') then
--RGB_out <= d2;
--elsif(active_area3 = '1') then
--RGB_out <= d3;
--elsif(active_area4 = '1') then
--RGB_out <= d4;
--else
--RGB_out <= (others => '0');
--end if;
--end if;
--end process;

--RGB_out <=
--d1 when active_area1 = '1' else
--d2 when active_area2 = '1' else
--d3 when active_area3 = '1' else
--d4 when active_area4 = '1' else
--"00000000";

end Behavioral;

>>>>>>>> r1/new_init_qvga:new_init_qvga/vga_imagegenerator.vhd
