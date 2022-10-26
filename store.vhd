

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity store is
  Port ( 
            clk, reset  : in std_logic;
            
            store_en    : in std_logic;
            data_out    : in std_logic_vector(17 downto 0)
            
            --store_data  : out std_logic_vector(17 downto 0)
  
  );
end store;

architecture Behavioral of store is

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
signal address      : std_logic_vector(7 downto 0) := (others => '0');
signal RY_ram       : std_logic;
signal sram_out     : std_logic_vector(31 downto 0);
---------------------------------------------------
signal address_nxt  : std_logic_vector(7 downto 0);


signal store_data_32 : std_logic_vector(31 downto 0);

begin
--SRAM bits transfer----------------------
store_data_32 <= "00000000000000" & data_out;
------------------------------------------

Ram_coeff: SRAM_SP_WRAPPER
port map(
    ClkxCI             => clk             ,
    CSxSI              => choose          , -- Active Low 
    WExSI              => r_or_w          , -- Active Low --only write in this module
    AddrxDI            => address         ,
    RYxSO              => RY_ram          ,
    DataxDI            => store_data_32   ,
    DataxDO            => sram_out 
    );


process(reset, store_en)
begin 

if reset = '1' then 
    choose <= '1';
    r_or_w <= '1'; --read
    address_nxt <= (others => '0');
else 
    if store_en = '1' then 
        choose <= '0';
        r_or_w <= '0'; --write
        address_nxt <= address + 1;
    else 
        choose <= '1';
        r_or_w <= '1'; --read
        address_nxt <= address;
    end if;

end if;


end process;


data_address: FF 
  generic map(N => 8)
  port map(   D     =>address_nxt,
              Q     =>address,
            clk     =>clk,
            reset   =>reset
      );

end Behavioral;
