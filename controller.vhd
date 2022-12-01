

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity controller is
  Port ( 
            clk, reset  : in std_logic;
            start       : in std_logic;
            
            ld2mem_done : in std_logic;
            ld_input_done   : in std_logic;
            multi_done  : in std_logic;
            
            ld2mem      : out std_logic;
            ld_input    : out std_logic;
            op_en       : out std_logic
  
  );
end controller;

architecture Behavioral of controller is

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;

type state_type is (s_initial, s_ld_coeff, s_ld_input, s_op);
signal state_reg, state_nxt : state_type;

signal flag1, flag1_nxt : std_logic_vector(0 downto 0) := (others => '0');
signal counter14, counter14_nxt : std_logic_vector(3 downto 0) := (others => '0');


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
process(state_reg, start, flag1, ld2mem_done, ld_input_done, multi_done, counter14)
begin
    
    ld2mem <= '0';
    ld_input <= '0';
    op_en <= '0';
    flag1_nxt <= "0";
    counter14_nxt <= counter14;

    case state_reg is 
    
        when s_initial =>
        counter14_nxt <= (others => '0'); 
            if start = '1' and flag1(0) = '0' then 
               state_nxt <= s_ld_coeff;
            elsif start = '0' and flag1(0) = '0' then
                state_nxt <= s_initial;           
            elsif start = '1' and flag1(0) = '1' then 
               flag1_nxt <= "1";
               state_nxt <= s_ld_input;
            else
               flag1_nxt <= "1";
               state_nxt <= s_initial;
            end if;
            
        
        when s_ld_coeff => 
            flag1_nxt <= "1";
            ld2mem <= '1';
            if ld2mem_done = '1' then 
                state_nxt <= s_ld_input;
            else 
                state_nxt <= s_ld_coeff;
            end if;

        
        when s_ld_input => 
            flag1_nxt <= "1";
            
            ld_input <= '1';
            if ld_input_done = '1' then 
                state_nxt <= s_op;
            else 
                state_nxt <= s_ld_input;
            end if;
            
--            if counter14 = "1110" then
--                ld_input <= '0';
--                state_nxt <= s_initial;
--            else 
--                ld_input <= '1';
--                if ld_input_done = '1' then 
--                    state_nxt <= s_op;
--                else 
--                    state_nxt <= s_ld_input;
--                end if;
                
--            end if;
            
        
        when s_op => 
            flag1_nxt <= "1";
            op_en <= '1'; 
            
            
            if multi_done = '1' then 
--                counter14_nxt <= counter14 + 1;
                if counter14 = "1101" then 
                    counter14_nxt <= (others => '0');
                    state_nxt <= s_initial;
                else
                    counter14_nxt <= counter14 + 1;
                    state_nxt <= s_ld_input;
                end if;
            else
                counter14_nxt <= counter14;
                state_nxt <= s_op;
            end if;            
            
            
            
            
--            if multi_done = '1' then 
--                counter14_nxt <= counter14 + 1;
--                state_nxt <= s_ld_input;
--            else
--                counter14_nxt <= counter14;
--                state_nxt <= s_op;
--            end if;
        
    
    end case;



end process;

flag_01: FF 
  generic map(N => 1)
  port map(   D     =>flag1_nxt,
              Q     =>flag1,
            clk     =>clk,
            reset   =>reset
      );

counter_14: FF 
  generic map(N => 4)
  port map(   D     =>counter14_nxt,
              Q     =>counter14,
            clk     =>clk,
            reset   =>reset
      );

end Behavioral;
