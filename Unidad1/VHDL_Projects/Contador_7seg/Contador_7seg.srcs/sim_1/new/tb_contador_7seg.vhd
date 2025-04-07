library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_contador_7seg is
end tb_contador_7seg;

architecture sim of tb_contador_7seg is
    component contador_7seg is
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            display : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal display_tb : std_logic_vector(6 downto 0);
    constant clk_period : time := 10 ns; -- Periodo del reloj

    function display_to_char(disp : std_logic_vector(6 downto 0)) return character is
    begin
        case disp is
            when "1000000" => return '0';
            when "1111001" => return '1';
            when "0100100" => return '2';
            when "0110000" => return '3';
            when "0011001" => return '4';
            when "0010010" => return '5';
            when "0000010" => return '6';
            when "1111000" => return '7';
            when others => return '-';  -- No válido
        end case;
    end function;

begin
    uut: contador_7seg
    port map (
        clk => clk_tb,
        reset => reset_tb,
        display => display_tb
    );

    process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    process
    begin
        reset_tb <= '1';  -- Activa reset
        wait for 20 ns;
        reset_tb <= '0';  -- Desactiva reset
        
        wait for 5000 ns; -- Corre la simulación por varios ciclos
        reset_tb <= '1';  -- Reinicia el sistema
        wait for 20 ns;
        reset_tb <= '0';
        wait for 5000 ns;
        assert false report "Simulación completada correctamente" severity note;
        wait;
    end process;

    process(display_tb)
    begin
        report "Display muestra: " & character'image(display_to_char(display_tb));
    end process;

end sim;
