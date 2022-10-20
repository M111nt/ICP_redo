

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity load_coeff is
  Port ( 
            clk, reset  : in std_logic;
            
            --load coeff part 
            
            --signal from controller 
            ld2mem      : in std_logic;
            --read data
            coeff       : in std_logic_vector(15 downto 0);     
            --feedback to controller 
            ld2mem_done : out std_logic;
            --coeff to memory   
            coeff2mem   : out std_logic_vector(15 downto 0);
            
            
            --op part 
            --signal from controller 
            op_en       : in std_logic;
            --control signal to multiply
            multi_en    : out std_logic;
            --coeff to multiply
            data_coeff  : out std_logic_vector(15 downto 0)

  
  );
end load_coeff;

architecture Behavioral of load_coeff is

component SRAM_SP_WRAPPER
  port (
    ClkxCI  : in  std_logic;
    CSxSI   : in  std_logic;            -- Active Low
    WExSI   : in  std_logic;            --Active Low
    AddrxDI : in  std_logic_vector (7 downto 0);
    RYxSO   : out std_logic;
    DataxDI : in  std_logic_vector (31 downto 0);
    DataxDO : out std_logic_vector (31 downto 0)
    );
end component;

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  : out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;



--SRAM---------------------------------------------
signal r_or_w       : std_logic; -- Active Low (reand & write)
signal choose       : std_logic;
signal address      : std_logic_vector(7 downto 0);
signal RY_ram       : std_logic;
---------------------------------------------------


type state_type is (s_initial, s_ld_coeff, s_op);
signal state_reg, state_nxt : state_type;

signal reg, reg_nxt : std_logic_vector(15 downto 0);
signal counter_1, counter_1_nxt : std_logic_vector(5 downto 0);
signal counter_2, counter_2_nxt : std_logic_vector(5 downto 0);


begin

Ram_coeff: SRAM_SP_WRAPPER
port map(
    ClkxCI             => clk             ,
    CSxSI              => r_or_w          , -- Active Low --only write in this module
    WExSI              => choose          , -- Active Low
    AddrxDI            => address         ,
    RYxSO              => RY_ram          ,
    DataxDI            => coeff           ,
    DataxDO            => data_coeff 
    );

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

process(state_reg, ld2mem, op_en)
begin
    
    case state_reg is 
        when s_initial => 
            if ld2mem = '1' and op_en = '0' then 
                state_nxt <= s_ld_coeff;
            elsif ld2mem = '0' and op_en = '1' then 
                state_nxt <= s_op;
            else 
                state_nxt <= s_initial;
            end if;
        
        when s_ld_coeff => 
            
        
        when s_op =>
        
    
    end case;

end process;


coefficient: FF 
  generic map(N => 16)
  port map(   D     =>reg_nxt,
              Q     =>reg,
            clk     =>clk,
            reset   =>reset
      );

counter1: FF 
  generic map(N => 6)
  port map(   D     =>counter_1_nxt,
              Q     =>counter_1,
            clk     =>clk,
            reset   =>reset
      );



end Behavioral;
