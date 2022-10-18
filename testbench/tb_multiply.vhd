
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_multiply is
end tb_multiply;

architecture Behavioral of tb_multiply is

component multiply is
  Port (
            clk, reset  : in std_logic;
            --ctrl in
            multi_en    : in std_logic;
            --data in
            data_input : in std_logic_vector(15 downto 0);
            data_coeff : in std_logic_vector(15 downto 0); 
            
            --ctrl out 
            multi_done  : out std_logic;
            --data out
            data_out : out std_logic_vector(22 downto 0)
          
  );
end component;

    signal clk          : std_logic := '1';      
    signal reset        : std_logic;  
    signal multi_en : std_logic;
    signal data_input   : std_logic_vector(15 downto 0);
    signal data_coeff   : std_logic_vector(15 downto 0); 
    signal multi_done   : std_logic;
    signal data_out : std_logic_vector(22 downto 0);

    constant period1    : time := 5ns;

begin

dut: multiply 
port map(
    clk        => clk,       
    reset      => reset,     
    multi_en   => multi_en, 
    data_input => data_input,
    data_coeff => data_coeff,
    multi_done => multi_done,
    data_out   => data_out 
    
);

clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 
         
multi_en <= '0', 
         '1' after 8*period1, 
         '0' after 10*period1;        

data_input <=   "0000000000000000" after 0*period1,
                "0000000100000001" after 10*period1,
                "0000001000000010" after 14*period1,
                "0000001100000011" after 18*period1,
                "0000010000000100" after 22*period1,
                "0000010100000101" after 26*period1;

data_coeff <=   "0000000000000000" after 0*period1,
                "0000000100000001" after 10*period1,
                "0000001000000010" after 14*period1,
                "0000001100000011" after 18*period1,
                "0000010000000100" after 22*period1,
                "0000010100000101" after 26*period1;

end Behavioral;
