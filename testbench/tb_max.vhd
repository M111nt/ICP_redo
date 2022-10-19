
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_max is
end tb_max;

architecture Behavioral of tb_max is

component max is
  Port (
            clk, reset  : in std_logic;
            
            --control signal from multiply 
            max_en  : in std_logic;
            --data from multiply 
            data_out : in std_logic_vector(17 downto 0);
            
            --find the maximum data
            max_out : out std_logic_vector(17 downto 0)   
                  
  );
end component;

    signal clk : std_logic := '1';
    signal reset : std_logic;
    signal max_en  : std_logic;
    signal data_out : std_logic_vector(17 downto 0);
    signal max_out : std_logic_vector(17 downto 0);   
    
    constant period1    : time := 5ns;


begin

dut: max 
port map(
            clk      => clk,     
            reset    => reset,   
            max_en   => max_en,  
            data_out => data_out,
            max_out  => max_out 
);

clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 

max_en <= '0', 
            '1' after 50*period1,
            '0' after 52*period1;

data_out <= "000000000000000000",
            "000000000000010000" after 10*period1,
            "010000000000000000" after 20*period1,
            "000000001000000000" after 30*period1;

end Behavioral;
