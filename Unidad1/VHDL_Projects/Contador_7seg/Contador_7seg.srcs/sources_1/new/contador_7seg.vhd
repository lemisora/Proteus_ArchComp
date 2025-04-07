library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_7seg is
    Port ( 
        clk : in STD_LOGIC;         -- Señal de reloj
        reset : in STD_LOGIC;       -- Reset asíncrono
        display : out STD_LOGIC_VECTOR (6 downto 0) -- Salida para 7 segmentos (a-g)
    );
end contador_7seg;

architecture Behavioral of contador_7seg is
    signal contador : unsigned(2 downto 0) := "000"; -- Contador de 3 bits (0-7)
    signal direccion : std_logic := '1';  -- '0' ascendente, '1' descendente
    signal slow_clk : STD_LOGIC := '0';   -- Reloj lento para visualización
    
    constant SIMULATION : boolean := true; -- Cambiar a false para síntesis
    constant CLK_DIVIDER_SIM : integer := 5; -- Valor pequeño para simulación
    constant CLK_DIVIDER_SYNTH : integer := 25000000; -- Valor para implementación real
    
    signal clk_divider : integer range 0 to 25000000 := 0; -- Divisor de reloj
    signal max_count : integer := 5; -- Se establecerá según modo simulación/síntesis
    
    signal contador_jk : unsigned(2 downto 0) := "000";
    signal dir_jk : std_logic := '1';  -- Inicia descendente
    
    signal contador_t : unsigned(2 downto 0) := "000";
    signal dir_t : std_logic := '1';  -- Inicia descendente
    
    signal contador_d : unsigned(2 downto 0) := "000";
    signal dir_d : std_logic := '1';  -- Inicia descendente
    
    signal contador_rs : unsigned(2 downto 0) := "000";
    signal dir_rs : std_logic := '1';  -- Inicia descendente

begin
    max_count <= CLK_DIVIDER_SIM when SIMULATION else CLK_DIVIDER_SYNTH;

    process(clk, reset)
    begin
        if reset = '1' then
            clk_divider <= 0;
            slow_clk <= '0';
        elsif rising_edge(clk) then
            if clk_divider = max_count then
                clk_divider <= 0;
                slow_clk <= not slow_clk;
            else
                clk_divider <= clk_divider + 1;
            end if;
        end if;
    end process;

    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador <= "000";
            direccion <= '1';  -- Inicia descendente
        elsif rising_edge(slow_clk) then
            report "Contador: " & integer'image(to_integer(contador)) & ", Dirección: " & std_logic'image(direccion);
            if direccion = '0' then -- Ascendente
                if contador = "111" then
                    direccion <= '1';  -- Cambiar a descendente
                else
                    contador <= contador + 1;
                end if;
            else -- Descendente
                if contador = "000" then
                    direccion <= '0';  -- Cambiar a ascendente
                else
                    contador <= contador - 1;
                end if;
            end if;
        end if;
    end process;

    -- Simulación de flip-flops (JK, T, D, RS) -- Se mantiene igual
    -- Procesos para manejar cada uno de ellos con lógica ascendente y descendente.
    -- No se incluye aquí para no repetir.
    
        -- Simulación de contador con JK flip-flops
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador_jk <= "000";
            dir_jk <= '1';  -- Iniciar en dirección descendente
        elsif rising_edge(slow_clk) then
            if dir_jk = '0' and contador_jk = "111" then
                dir_jk <= '1';  -- Cambiar a descendente
            elsif dir_jk = '1' and contador_jk = "000" then
                dir_jk <= '0';  -- Cambiar a ascendente
            end if;
            
            if dir_jk = '0' then -- Ascendente
                contador_jk(0) <= not contador_jk(0);
                if contador_jk(0) = '1' then
                    contador_jk(1) <= not contador_jk(1);
                end if;
                if contador_jk(1) = '1' and contador_jk(0) = '1' then
                    contador_jk(2) <= not contador_jk(2);
                end if;
            else -- Descendente
                contador_jk(0) <= not contador_jk(0);
                if contador_jk(0) = '0' then
                    contador_jk(1) <= not contador_jk(1);
                end if;
                if contador_jk(1) = '0' and contador_jk(0) = '0' then
                    contador_jk(2) <= not contador_jk(2);
                end if;
            end if;
        end if;
    end process;

    -- Simulación de contador con T flip-flops
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador_t <= "000";
            dir_t <= '1';  -- Iniciar en dirección descendente
        elsif rising_edge(slow_clk) then
            if dir_t = '0' and contador_t = "111" then
                dir_t <= '1';  -- Cambiar a descendente
            elsif dir_t = '1' and contador_t = "000" then
                dir_t <= '0';  -- Cambiar a ascendente
            end if;
            
            if dir_t = '0' then -- Ascendente
                contador_t(0) <= not contador_t(0);
                if contador_t(0) = '1' then
                    contador_t(1) <= not contador_t(1);
                end if;
                if contador_t(1) = '1' and contador_t(0) = '1' then
                    contador_t(2) <= not contador_t(2);
                end if;
            else -- Descendente
                contador_t(0) <= not contador_t(0);
                if contador_t(0) = '0' then
                    contador_t(1) <= not contador_t(1);
                end if;
                if contador_t(1) = '0' and contador_t(0) = '0' then
                    contador_t(2) <= not contador_t(2);
                end if;
            end if;
        end if;
    end process;

    -- Simulación de contador con D flip-flops
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador_d <= "000";
            dir_d <= '1';  -- Iniciar en dirección descendente
        elsif rising_edge(slow_clk) then
            if dir_d = '0' and contador_d = "111" then
                dir_d <= '1';  -- Cambiar a descendente
            elsif dir_d = '1' and contador_d = "000" then
                dir_d <= '0';  -- Cambiar a ascendente
            end if;
            
            if dir_d = '0' then -- Ascendente
                contador_d(0) <= not contador_d(0);
                contador_d(1) <= contador_d(1) xor contador_d(0);
                contador_d(2) <= contador_d(2) xor (contador_d(1) and contador_d(0));
            else -- Descendente
                contador_d(0) <= not contador_d(0);
                contador_d(1) <= contador_d(1) xor (not contador_d(0));
                contador_d(2) <= contador_d(2) xor ((not contador_d(1)) and (not contador_d(0)));
            end if;
        end if;
    end process;

    -- Simulación de contador con RS flip-flops
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador_rs <= "000";
            dir_rs <= '1';  -- Iniciar en dirección descendente
        elsif rising_edge(slow_clk) then
            if dir_rs = '0' and contador_rs = "111" then
                dir_rs <= '1';  -- Cambiar a descendente
            elsif dir_rs = '1' and contador_rs = "000" then
                dir_rs <= '0';  -- Cambiar a ascendente
            end if;
            
            if dir_rs = '0' then -- Ascendente
                contador_rs <= contador_rs + 1;
            else -- Descendente
                contador_rs <= contador_rs - 1;
            end if;
        end if;
    end process;

    process(contador)
    begin
        case to_integer(contador) is
            when 0 => display <= "1000000"; -- 0
            when 1 => display <= "1111001"; -- 1
            when 2 => display <= "0100100"; -- 2
            when 3 => display <= "0110000"; -- 3
            when 4 => display <= "0011001"; -- 4
            when 5 => display <= "0010010"; -- 5
            when 6 => display <= "0000010"; -- 6
            when 7 => display <= "1111000"; -- 7
            when others => display <= "1111111"; -- Apagado
        end case;
    end process;

end Behavioral;
