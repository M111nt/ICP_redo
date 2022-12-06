

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_load_coeff is

end tb_load_coeff;

architecture Behavioral of tb_load_coeff is

component load_coeff is
  Port ( 
            clk, reset  : in std_logic;
            ld2mem      : in std_logic;
            coeff       : in std_logic_vector(15 downto 0);     
            start_ld    : out std_logic;
            ld2mem_done : out std_logic;
            --coeff2mem   : out std_logic_vector(15 downto 0);
            op_en       : in std_logic;
            multi_en    : out std_logic;
            data_coeff  : out std_logic_vector(15 downto 0)
  );
end component;

signal clk         : std_logic := '1'; 
signal reset       : std_logic;                     
signal ld2mem      : std_logic;                     
signal coeff       : std_logic_vector(15 downto 0); 
signal start_ld    : std_logic;                    
signal ld2mem_done : std_logic;                    
--signal coeff2mem   : std_logic_vector(15 downto 0);
signal op_en       : std_logic;                     
signal multi_en    : std_logic;                    
signal data_coeff  : std_logic_vector(15 downto 0); 

constant period1    : time := 5ns;


begin

dut: load_coeff
port map(
clk             => clk          ,
reset           => reset         ,
ld2mem          => ld2mem       ,
coeff           => coeff        ,
start_ld        => start_ld     ,
ld2mem_done     => ld2mem_done  ,
--coeff2mem       => coeff2mem    ,
op_en           => op_en        ,
multi_en        => multi_en     ,
data_coeff      => data_coeff   
);




clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 

ld2mem <= '0',
            '1' after 10*period1,
            '0' after 12*period1;
            
coeff <= "0000000000000000",
         
         "0000000100000001" after 12*period1,
         "0000001000000010" after 14*period1,
         "0000001100000011" after 16*period1,
         "0000010000000100" after 18*period1,
         "0000010100000101" after 20*period1,
         "0000011000000110" after 22*period1,
         "0000011100000111" after 24*period1,
         "0000100000001000" after 26*period1,
         "0000100100001001" after 28*period1,
         "0000101000001010" after 30*period1,
         
         "0000000100000001" after 32*period1,
         "0000001000000010" after 34*period1,
         "0000001100000011" after 36*period1,
         "0000010000000100" after 38*period1,
         "0000010100000101" after 40*period1,
         "0000011000000110" after 42*period1,
         "0000011100000111" after 44*period1,
         "0000100000001000" after 46*period1,
         "0000100100001001" after 48*period1,
         "0000101000001010" after 50*period1,
         
         "0000000100000001" after 52*period1,
         "0000001000000010" after 54*period1,
         "0000001100000011" after 56*period1,
         "0000010000000100" after 58*period1,
         "0000010100000101" after 60*period1,
         "0000011000000110" after 62*period1,
         "0000011100000111" after 64*period1,
         "0000100000001000" after 66*period1,
         "0000100100001001" after 68*period1,
         "0000101000001010" after 70*period1,
         
         "0000000100000001" after 72*period1,
         "0000001000000010" after 74*period1,
         "0000001100000011" after 76*period1,
         "0000010000000100" after 78*period1,
         "0000010100000101" after 80*period1,
         "0000011000000110" after 82*period1,
         "0000011100000111" after 84*period1,
         "0000100000001000" after 86*period1,
         "0000100100001001" after 88*period1,
         "0000101000001010" after 90*period1,
         
         "0000000100000001" after 92*period1,
         "0000001000000010" after 94*period1,
         "0000001100000011" after 96*period1,
         "0000010000000100" after 98*period1,
         "0000010100000101" after 100*period1,
         "0000011000000110" after 102*period1,
         "0000011100000111" after 104*period1,
         "0000100000001000" after 106*period1,
         "0000100100001001" after 108*period1,
         "0000101000001010" after 110*period1,
         
         "0000000100000001" after 112*period1,
         "0000001000000010" after 114*period1,
         "0000001100000011" after 116*period1,
         "0000010000000100" after 118*period1,
         "0000010100000101" after 120*period1,
         "0000011000000110" after 122*period1,
         
         "0000000000000000" after 124*period1;


op_en <= '0', 
         '1' after 130*period1,
         '0' after 132*period1;








end Behavioral;
