library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity input_gen is
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
end input_gen;

architecture Behavioral of input_gen is

begin

  process (clk, reset)
        file test_vector_file: text open read_mode is FILE_NAME;
        variable file_row: line;
        variable input_raw: bit_vector(INPUT_WIDTH-1 downto 0);
    begin
        if (reset = '1') then
            input_sample <= (others => '0');  
        elsif rising_edge(clk) then
           -- input_raw := 0;
            if not endfile(test_vector_file) and start_ld_inputo ='1' then
                readline(test_vector_file, file_row);
                read(file_row, input_raw);                
            end if;
            input_sample <=to_stdlogicvector(input_raw);
        end if;
    end process;

end Behavioral;
