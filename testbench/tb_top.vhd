
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

component top is
  Port ( 
        clki            : in std_logic;
        reseti          : in std_logic;
        starti          : in std_logic;
        inputi          : in std_logic_vector(15 downto 0);
        start_ld_inputo : out std_logic;
        start_ld_coeffo : out std_logic;
        max_outo        : out std_logic_vector(17 downto 0)
  );
end component;

component coeff_gen is
    generic (
        FILE_NAME: string ;
        INPUT_WIDTH: positive
        ); 
    Port (
        clk: in std_logic;
        reset: in std_logic;
        start_ld_coeffo: in std_logic;
        input_sample: out std_logic_vector(INPUT_WIDTH-1 downto 0)
        );
end component;

component input_gen is
    generic (
        FILE_NAME: string ;
        INPUT_WIDTH: positive
        ); 
    Port (
        clk: in std_logic;
        reset: in std_logic;
        start_ld_inputo: in std_logic;
        input_sample: out std_logic_vector(INPUT_WIDTH-1 downto 0)
        );
end component;

    signal clk             : std_logic := '1';      
    signal reset           : std_logic;    
    signal starti          : std_logic;
    signal inputi          : std_logic_vector(15 downto 0);
    signal input1, input2  : std_logic_vector(15 downto 0);
    signal start_ld_inputo : std_logic;
    signal start_ld_coeffo : std_logic;
    signal max_outo        : std_logic_vector(17 downto 0);
        
    constant period1       : time := 5ns;


begin

dut: top
port map(
            clki            => clk            ,
            reseti          => reset          ,
            starti          => starti          ,
            inputi          => inputi          ,
            start_ld_inputo => start_ld_inputo ,
            start_ld_coeffo => start_ld_coeffo ,
            max_outo        => max_outo        
);


coeff_w: coeff_gen
generic map (
        FILE_NAME =>"C:\Users\Hanyu Liu\Desktop\ICP_redo\coeff.txt", 
        INPUT_WIDTH => 16
        ) 
port map(
            clk             => clk            ,
            reset           => reset          ,
            start_ld_coeffo => start_ld_coeffo,
            input_sample    => input1   
);

input_w: input_gen
generic map (
        FILE_NAME =>"C:\Users\Hanyu Liu\Desktop\ICP_redo\input.txt", 
        INPUT_WIDTH => 16
        ) 
port map(
            clk             => clk            ,
            reset           => reset          ,
            start_ld_inputo => start_ld_inputo,
            input_sample    => input2  
);


clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 
         
starti <= '0',
            '1' after 10*period1,
            '0' after 12*period1;

inputi <= input1 when start_ld_coeffo = '1' else
          input2 when start_ld_inputo = '1' else
          (others => '0');


end Behavioral;
