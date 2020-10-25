library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CA_5_TOP is
Port ( AddBus_ProcA, AddBus_ProcB, AddBus_ProcC: in std_logic_vector(11 downto 0);
       DataWriteBus_ProcA, DataWriteBus_ProcB, DataWriteBus_ProcC: in std_logic_vector(7 downto 0);
       addBUS_RAM: out std_logic_vector(11 downto 0);
       DataWriteBus_Ram: out std_logic_vector(7 downto 0);
       WeA, WeB, WeC, clk, rst: in std_logic;
       RegA,RegB, RegC: in std_logic;     
       AckA, AckB, AckC, We: out std_logic);
       
end CA_5_TOP;
architecture Behavioral of CA_5_TOP is

component Arbiter2 is 
Port ( AddBus_ProcA, AddBus_ProcB, AddBus_ProcC: in std_logic_vector(11 downto 0);
       DataWriteBus_ProcA, DataWriteBus_ProcB, DataWriteBus_ProcC: in std_logic_vector(7 downto 0);
       addBUS_RAM: out std_logic_vector(11 downto 0);
       DataWriteBus_Ram: out std_logic_vector(7 downto 0);
       WeA, WeB, WeC,clk, rst: in std_logic;
       RegA,RegB, RegC: in std_logic;     
       AckA, AckB, AckC, We: out std_logic);
end component; 

begin

C5: Arbiter2 port map(
                      AddBus_ProcA => AddBus_ProcA,
                      AddBus_ProcB => AddBus_ProcB,
                      AddBus_ProcC => AddBus_ProcC,
                      DataWriteBus_ProcA  =>  DataWriteBus_ProcA,
                      DataWriteBus_ProcB =>  DataWriteBus_ProcB,
                      DataWriteBus_ProcC =>  DataWriteBus_ProcC,
                      addBUS_RAM =>  addBUS_RAM,
                      DataWriteBus_Ram => DataWriteBus_Ram,
                      WeA =>  WeA, 
                      WeB =>  WeB,
                      Wec  => WeC,
                      clk =>  clk, 
                      rst  => rst,
                      RegA  =>  RegA,
                      RegB  =>  RegB, 
                      RegC  => RegC,
                      AckA  =>  AckA, 
                      AckB  =>  AckB, 
                      AckC  =>   AckC, 
                      We => We);            
end Behavioral;
b.	Secound Level 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Arbiter2 is
Port ( AddBus_ProcA, AddBus_ProcB, AddBus_ProcC: in std_logic_vector(11 downto 0);
       DataWriteBus_ProcA, DataWriteBus_ProcB, DataWriteBus_ProcC: in std_logic_vector(7 downto 0);
       addBUS_RAM: out std_logic_vector(11 downto 0);
       DataWriteBus_Ram: out std_logic_vector(7 downto 0);
       WeA, WeB, WeC,clk, rst: in std_logic;
       RegA,RegB, RegC: in std_logic;     
       AckA, AckB, AckC, We: out std_logic);
end Arbiter2;

architecture Behavioral of Arbiter2 is
type state_type is (idle, Grant_A, Grant_B, Grant_C);
signal current_state, next_state: state_type;

 signal delay_shift_reg : std_logic_vector(30 downto 0) := "0000000000000000000000000000001";

signal ADDRESS: std_logic_vector(11 downto 0);
signal DATA_W: std_logic_vector(7 downto 0);

begin

SYNC_PROC: process(clk)

begin
 
if (rising_edge(clk)) then
    if (rst='1') then
        current_state <= idle;
        We <= '0';
    else 
       current_state <= next_state;
        We <= '1';
  end if;
end if;

end process;   

NEXT_STATE_DECODE: process(clk)

begin
AckA <= '0';
AckB <= '0';
AckC <= '0';
if (rising_edge(clk)) then 
 if delay_shift_reg(0) = '1' then      
case(Current_state) is
   when idle => 
        if RegA='1'  and WeA ='1' then
            next_state<=Grant_A;
            AckA <= '1';
            ADDRESS<=AddBus_ProcA;
            DATA_W <=DataWriteBus_ProcA;
              
          end if;
                 
   When Grant_A =>
        if RegB = '1' and WeB ='1' then
            next_state <= Grant_B;
            ADDRESS<=AddBus_ProcB;
            AckB <= '1';
            DATA_W <=DataWriteBus_ProcB;
             
        elsif RegC = '1'  and WeC='1' then
            next_state <= Grant_C;
            AckC <= '1';
            ADDRESS<=AddBus_ProcC;
            DATA_W <=DataWriteBus_ProcC;
        
        elsif RegA = '1'  and WeA ='1'then
            next_state <= current_state;
            AckA <= '1';
            ADDRESS<=AddBus_ProcA;
            DATA_W <=DataWriteBus_ProcA;
            
        else 
            next_state <=Idle;
            ADDRESS <=ADDRESS;
            DATA_W <=DataWriteBus_ProcA;
        end if;
             
    when Grant_B =>
        if RegC = '1'  and WeC ='1' then
        next_state <= Grant_C;
        AckC <= '1';
        ADDRESS<=AddBus_ProcC;
        DATA_W <=DataWriteBus_ProcC;
        
        elsif RegA = '1'and WeA ='1' then
        next_state <= Grant_A;
        AckA <= '1';
        ADDRESS<=AddBus_ProcA;
        DATA_W <=DataWriteBus_ProcA;
        
        elsif RegB = '1'  and WeB ='1' then
            next_state <= current_state;
            AckB <= '1';
            ADDRESS<=AddBus_ProcB;
            DATA_W <=DataWriteBus_ProcB;
            
        else 
             next_state <=Idle;
             ADDRESS <=ADDRESS;
             DATA_W <=DataWriteBus_ProcB;
        end if;
    
     when Grant_C =>
        if RegA = '1'  and WeA ='1' then
        next_state <= Grant_A;
        AckA <= '1';
        ADDRESS<=AddBus_ProcA;
        DATA_W <=DataWriteBus_ProcA;
        
        elsif RegB = '1'  and WeB ='1'  then
        next_state <= Grant_B;
        AckB <= '1';
        ADDRESS<=AddBus_ProcB;
        DATA_W <=DataWriteBus_ProcB;
        
        elsif RegC = '1'  and WeC ='1'then
            next_state <= current_state;
            AckC <= '1';
            ADDRESS<=AddBus_ProcC;
            DATA_W <=DataWriteBus_ProcC;
            
        else 
             next_state <=Idle;
             ADDRESS <=ADDRESS;
             DATA_W <=DataWriteBus_ProcC;
        end if;
    
  end case;  
    end if;  
    delay_shift_reg <= delay_shift_reg(29 downto 0) & delay_shift_reg(30);
 end if;
end process; 

addBUS_RAM <= ADDRESS;
DataWriteBus_Ram <= DATA_W;
end Behavioral;
