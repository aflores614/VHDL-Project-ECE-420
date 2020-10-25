library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use std.textio.all;
entity TOP_level is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end TOP_level;

architecture Behavioral of TOP_level is
signal din: std_logic_vector(15 downto 0);
signal dout, dout_reg: std_logic_vector(15 downto 0);
signal addr_out: std_logic_vector(15 downto 0);
signal re, we: std_logic; 
signal addr_in: std_logic_vector(15 downto 0);
signal Counter: std_logic_vector( 15 downto 0) := "0000000000000000";

component blk_mem_gen_0 is
    port(
         addra:in std_logic_vector(15 downto 0);
         ckla: in std_logic;
         dina: in std_logic_vector(15 downto 0);
         douta: out std_logic_vector(15 downto 0);
         ena: in std_logic;
         wea:in std_logic
         );
end component;

begin

C6: blk_mem_gen_0 port map( addra => addr_in,
                            ckla => clk,
                            dina  =>  din,
                            douta => dout,
                            ena => re,
                            wea => we
                            );
                         

process(clk)
begin
    if(rising_edge(clk)) then
        if rst ='1' then
            dout_reg <= "0000000000000000";
            din <= "0000000000000000";
        else 
            dout_reg <= dout;
            din <= addr_out;
        end if;
    end if;
 end process;
   
 addr_out <= dout_reg + dout;  
 
 process(clk)
 begin
 
 if rising_edge(clk) then
    if Counter < "11111111111111111111" then
       Counter <= Counter + '1';
    else 
        Counter <= "0000000000000000"; 
    end if;
 end if;
 
 end process;

 addr_in <= Counter;
 we   <= Counter(0) and Counter(1);
 re   <= not Counter(1);
 
end Behavioral;
