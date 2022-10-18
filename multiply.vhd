
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiply is
  Port (    
            --ctrl in
            multi_en    : in std_logic;
            reset       : in std_logic;
            clk         : in std_logic;
            --data in
            data_input : in std_logic_vector(15 downto 0);
            data_coeff : in std_logic_vector(15 downto 0); 
            
            --ctrl out 
            multi_done  : out std_logic;
            --data out
            data1_out : out std_logic_vector(15 downto 0);
            data2_out : out std_logic_vector(15 downto 0)

    );
end multiply;

architecture Behavioral of multiply is

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  : out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;


type state_type is (s_initial, s_multi, s_send);
signal state_reg, state_nxt : state_type;

signal input_1, input_2 : std_logic_vector(7 downto 0);
signal input_1_nxt, input_2_nxt : std_logic_vector(7 downto 0);

signal coeff_1, coeff_2 : std_logic_vector(7 downto 0);
signal coeff_1_nxt, coeff_2_nxt : std_logic_vector(7 downto 0);

signal result_1, result_2   : std_logic_vector(15 downto 0);
signal result1_out, result2_out : std_logic_vector(15 downto 0);



begin
  
--state contrl--------------------------------
process(clk, reset)
begin
    if reset = '1' then 
        state_reg <= s_initial; 
    elsif (clk'event and clk = '1') then 
        state_reg <= state_nxt; 
    end if;

end process;

--state machine--------------------------------------------
process(state_reg, multi_en)
begin
    multi_done <= '0';
    input_1 <= (others => '0');
    input_2 <= (others => '0');
    coeff_1 <= (others => '0');
    coeff_2 <= (others => '0');
    result1_out <= (others => '0');
    result2_out <= (others => '0');   
    
    case state_reg is 
        when s_initial => 
            if multi_en = '1' then 
                state_nxt <= s_multi;
            else
                state_nxt <= s_initial;
            end if;
        
        
        when s_multi =>
            input_1 <= data_input(7 downto 0);
            input_2 <= data_input(15 downto 8);
            coeff_1 <= data_coeff(6 downto 0);
            coeff_2 <= data_coeff(13 downto 7);
            state_nxt <= s_send;
               
        when s_send => 
            result1_out <= result_1;
            result2_out <= result_2;
            multi_done <= '1';
            
            state_nxt <= s_initial;
        
        
    end case;


end process;


result_1 <= input_1 * coeff_1; 
result_2 <= input_2 * coeff_2;

data1_out <= result1_out;
data2_out <= result2_out;


input_01: FF 
  generic map(N => 7)
  port map(   D     =>input_1_nxt,
              Q     =>input_1,
            clk     =>clk,
            reset   =>reset
      );
      
input_02: FF 
  generic map(N => 7)
  port map(   D     =>input_1_nxt,
              Q     =>input_1,
            clk     =>clk,
            reset   =>reset
      );

coeff_01: FF 
  generic map(N => 7)
  port map(   D     =>coeff_1_nxt,
              Q     =>coeff_1,
            clk     =>clk,
            reset   =>reset
      );

coeff_02: FF 
  generic map(N => 7)
  port map(   D     =>coeff_2_nxt,
              Q     =>coeff_2,
            clk     =>clk,
            reset   =>reset
      );



end Behavioral;
