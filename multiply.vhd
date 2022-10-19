
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiply is
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


type state_type is (s_initial, s_multi, s_add, s_send);
signal state_reg, state_nxt : state_type;

signal input_1, input_2 : std_logic_vector(7 downto 0);
signal input_1_nxt, input_2_nxt : std_logic_vector(7 downto 0);

signal coeff_1, coeff_2 : std_logic_vector(6 downto 0);
signal coeff_1_nxt, coeff_2_nxt : std_logic_vector(6 downto 0);

signal result_1, result_2   : std_logic_vector(14 downto 0);

--the matrix is [14*8]*[8*14], when counting 111 in binary means one number is done.
signal counter_8, counter_8_nxt     : std_logic_vector(1 downto 0) := (others => '0');
signal data, data_nxt   : std_logic_vector(22 downto 0);


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
process(state_reg, multi_en, counter_8, data, result_1, result_2)
begin
    multi_done <= '0';
    input_1_nxt <= (others => '0');
    input_2_nxt <= (others => '0');
    coeff_1_nxt <= (others => '0');
    coeff_2_nxt <= (others => '0'); 
    data_nxt <= (others => '0');
    counter_8_nxt <= (others => '0'); 
    data_out <= (others => '0');

    
    
    
    case state_reg is 
        when s_initial => 
            if multi_en = '1' then 
                state_nxt <= s_multi;
            else
                state_nxt <= s_initial;
            end if;
        
        
        when s_multi =>
            input_1_nxt <= data_input(7 downto 0);--the input has 8 bits
            input_2_nxt <= data_input(15 downto 8);
            coeff_1_nxt <= data_coeff(6 downto 0);--the coeff only has 7 bits
            coeff_2_nxt <= data_coeff(14 downto 8);
            
            data_nxt <= data;
            counter_8_nxt <= counter_8;
            state_nxt <= s_add;
            
        when s_add => 
            input_1_nxt <= input_1;
            input_2_nxt <= input_2;
            coeff_1_nxt <= coeff_1;
            coeff_2_nxt <= coeff_2;
            data_nxt <= result_1 + result_2 + data;
            if counter_8 = "11" then 
                counter_8_nxt <= (others => '0');
                state_nxt <= s_send;
            else 
                counter_8_nxt <= counter_8 + 1;
                state_nxt <= s_multi; 
            end if;
            
               
        when s_send => 
            multi_done <= '1';--feedback to controller & average 
            data_out <= data;
            
            state_nxt <= s_initial;
        
        
    end case;


end process;



result_1 <= input_1 * coeff_1; 
result_2 <= input_2 * coeff_2;



input_01: FF 
  generic map(N => 8)
  port map(   D     =>input_1_nxt,
              Q     =>input_1,
            clk     =>clk,
            reset   =>reset
      );
      
input_02: FF 
  generic map(N => 8)
  port map(   D     =>input_2_nxt,
              Q     =>input_2,
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

counter: FF 
  generic map(N => 2)
  port map(   D     =>counter_8_nxt,
              Q     =>counter_8,
            clk     =>clk,
            reset   =>reset
      );

add: FF 
  generic map(N => 23)
  port map(   D     =>data_nxt,
              Q     =>data,
            clk     =>clk,
            reset   =>reset
      );


end Behavioral;
