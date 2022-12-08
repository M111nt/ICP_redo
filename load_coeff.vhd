

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity load_coeff is
  Port ( 
            clk, reset  : in std_logic;
            
            --load coeff part -----------------------------------
            --signal from controller 
            ld2mem      : in std_logic;
            --read data
            coeff       : in std_logic_vector(15 downto 0);     
            --control signal 
            start_ld_coeff    : out std_logic;
            --feedback to controller 
            ld2mem_done : out std_logic;
            --coeff to memory   
            --coeff2mem   : out std_logic_vector(15 downto 0);
            
            -----------------------------------------------------
            
            --op part ------------------------------------------- 
            --signal from controller 
            op_en       : in std_logic;
            --control signal to multiply
            multi_en    : out std_logic;
            --coeff to multiply
            data_coeff  : out std_logic_vector(15 downto 0)
            
            -----------------------------------------------------

  
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
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;



--SRAM---------------------------------------------
signal choose       : std_logic;
signal r_or_w       : std_logic; -- Active Low (reand & write) --write '0' --read '1'
signal address      : std_logic_vector(7 downto 0);
signal RY_ram       : std_logic;
---------------------------------------------------


type state_type is (s_initial, s_ld_coeff, s_op, s_send2multi);
signal state_reg, state_nxt : state_type;

--signal reg, reg_nxt : std_logic_vector(15 downto 0);
signal counter_1, counter_1_nxt : std_logic_vector(5 downto 0) := (others => '0');
--signal counter_2, counter_2_nxt : std_logic_vector(5 downto 0);

signal coeff_32 : std_logic_vector(31 downto 0);
signal data_coeff_32 : std_logic_vector(31 downto 0);

begin
--SRAM bits transfer----------------------
coeff_32 <= "0000000000000000" & coeff;
data_coeff <= data_coeff_32(15 downto 0);
------------------------------------------

Ram_coeff: SRAM_SP_WRAPPER
port map(
    ClkxCI             => clk             ,
    CSxSI              => choose          , -- Active Low 
    WExSI              => r_or_w          , -- Active Low 
    AddrxDI            => address         ,
    RYxSO              => RY_ram          ,
    DataxDI            => coeff_32        ,
    DataxDO            => data_coeff_32
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

process(state_reg, ld2mem, op_en, counter_1)
begin
    
    --SRAM------------------------------
    choose <= '1';
    r_or_w <= '1';--read
    --address <= (others => '0');
    address <= "00" & counter_1;
    ------------------------------------

    start_ld_coeff <= '0';
    ld2mem_done <= '0';

    counter_1_nxt <= (others => '0');
    multi_en <= '0';
    
    
    case state_reg is 
        
        when s_initial => 
            if ld2mem = '1' and op_en = '0' then                 
                start_ld_coeff <= '1';
                state_nxt <= s_ld_coeff;
            elsif ld2mem = '0' and op_en = '1' then 
                --choose <= '0';
                state_nxt <= s_op;
            else 
                state_nxt <= s_initial;
            end if;
        
        when s_ld_coeff => 
            choose <= '0'; 
            r_or_w <= '0'; --write
            address <= "00" & counter_1;
            if counter_1 = "111000" then 
                ld2mem_done <= '1';
                counter_1_nxt <= (others => '0');
                state_nxt <= s_initial;
            else
                start_ld_coeff <= '1';
                counter_1_nxt <= counter_1 + 1;
                state_nxt <= s_ld_coeff;
            end if;           
        
        when s_op =>
            choose <= '0';
            r_or_w <= '1'; --read 
            address <= "00" & counter_1;
            counter_1_nxt <= counter_1;
            if counter_1 = "111000" then --counter = 56 (address = 0 -55)
                state_nxt <= s_initial; 
            elsif counter_1 = "000000" then 
                multi_en <= '1';
                state_nxt <= s_send2multi;
            else
                multi_en <= '0';
                state_nxt <= s_send2multi;
            end if;
            
         when s_send2multi => 
            choose <= '0';
            r_or_w <= '1'; --read
            address <= "00" & counter_1;

            counter_1_nxt <= counter_1 + 1;

            state_nxt <= s_op;
         
         
         
    
    end case;

end process;

--Flip Flop-------------------------------------------------
--coefficient: FF 
--  generic map(N => 16)
--  port map(   D     =>reg_nxt,
--              Q     =>reg,
--            clk     =>clk,
--            reset   =>reset
--      );

counter1: FF 
  generic map(N => 6)
  port map(   D     =>counter_1_nxt,
              Q     =>counter_1,
            clk     =>clk,
            reset   =>reset
      );



end Behavioral;
