library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entidad ALU basada en el 74LS181
entity ALU_74LS181 is
    Port ( 
        clk : in STD_LOGIC;                     -- Señal de reloj para sincronización
        A : in STD_LOGIC_VECTOR(3 downto 0);    -- Entrada A de 4 bits
        B : in STD_LOGIC_VECTOR(3 downto 0);    -- Entrada B de 4 bits
        S : in STD_LOGIC_VECTOR(3 downto 0);    -- Selección de función
        M : in STD_LOGIC;                       -- Modo: 0=Lógico, 1=Aritmético
        Cin : in STD_LOGIC;                     -- Acarreo de entrada (activo en bajo)
        
        F : out STD_LOGIC_VECTOR(3 downto 0);   -- Salida de función
        AeqB : out STD_LOGIC;                   -- Indicador de igualdad A=B
        Cout : out STD_LOGIC;                   -- Acarreo de salida (activo en bajo)
        P : out STD_LOGIC;                      -- Propagar (activo en bajo)
        G : out STD_LOGIC                       -- Generar (activo en bajo)
    );
end ALU_74LS181;

architecture Behavioral of ALU_74LS181 is
    signal P_internal : STD_LOGIC_VECTOR(3 downto 0);
    signal G_internal : STD_LOGIC_VECTOR(3 downto 0);
    signal Carry : STD_LOGIC_VECTOR(4 downto 0);
    signal result : STD_LOGIC_VECTOR(3 downto 0);
    -- Señales adicionales para evitar usar M como señal de reloj
    signal M_sync : STD_LOGIC;
    
begin
    -- Registramos la señal M para evitar usarla directamente en la lógica del reloj
    process(clk)
    begin
        if rising_edge(clk) then
            M_sync <= M;
        end if;
    end process;
    -- Proceso para implementar la ALU según hoja de datos del 74LS181
    process(A, B, S, M, Cin)
        variable logic_result : STD_LOGIC_VECTOR(3 downto 0);
    begin
        -- Implementar funciones de acuerdo a tabla de verdad del 74LS181
        -- Para cada bit de A y B, calculamos P y G
        for i in 0 to 3 loop
            case S is
                when "0000" => 
                    if M = '1' then -- Aritmético: F = A
                        logic_result(i) := A(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = NOT A
                        logic_result(i) := not A(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0001" => 
                    if M = '1' then -- Aritmético: F = A OR B
                        logic_result(i) := A(i) or B(i);
                        P_internal(i) <= B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = NOT (A AND B)
                        logic_result(i) := not (A(i) and B(i));
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0010" => 
                    if M = '1' then -- Aritmético: F = A OR NOT B
                        logic_result(i) := A(i) or not B(i);
                        P_internal(i) <= not B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = NOT A AND B
                        logic_result(i) := not A(i) and B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0011" => 
                    if M = '1' then -- Aritmético: F = MINUS 1 (ALL 1's)
                        logic_result(i) := '1';
                        P_internal(i) <= '1';
                        G_internal(i) <= '1';
                    else            -- Lógico: F = ZERO
                        logic_result(i) := '0';
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0100" => 
                    if M = '1' then -- Aritmético: F = A PLUS (A AND NOT B)
                        logic_result(i) := A(i) and not B(i);
                        P_internal(i) <= not B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = NOT A OR B
                        logic_result(i) := not A(i) or B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0101" => 
                    if M = '1' then -- Aritmético: F = (A OR B) PLUS (A AND NOT B)
                        logic_result(i) := A(i) or B(i);
                        P_internal(i) <= not B(i) or B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = NOT (A XOR B)
                        logic_result(i) := not (A(i) xor B(i));
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0110" => 
                    if M = '1' then -- Aritmético: F = A MINUS B MINUS 1
                        logic_result(i) := A(i) xor not B(i);
                        P_internal(i) <= not B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = A XOR B
                        logic_result(i) := A(i) xor B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "0111" => 
                    if M = '1' then -- Aritmético: F = A AND NOT B
                        logic_result(i) := A(i) and not B(i);
                        P_internal(i) <= not B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = A AND B
                        logic_result(i) := A(i) and B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1000" => 
                    if M = '1' then -- Aritmético: F = A PLUS (A AND B)
                        logic_result(i) := A(i) and B(i);
                        P_internal(i) <= B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = NOT A OR NOT B
                        logic_result(i) := not A(i) or not B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1001" => 
                    if M = '1' then -- Aritmético: F = A PLUS B
                        logic_result(i) := A(i) xor B(i);
                        P_internal(i) <= B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = NOT (A XOR B)
                        logic_result(i) := not (A(i) xor B(i));
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1010" => 
                    if M = '1' then -- Aritmético: F = (A AND B) PLUS (A AND NOT B)
                        logic_result(i) := A(i);
                        P_internal(i) <= B(i) or not B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = B
                        logic_result(i) := B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1011" => 
                    if M = '1' then -- Aritmético: F = (A AND B) MINUS 1
                        logic_result(i) := A(i) and B(i);
                        P_internal(i) <= B(i);
                        G_internal(i) <= '0';
                    else            -- Lógico: F = A OR B
                        logic_result(i) := A(i) or B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1100" => 
                    if M = '1' then -- Aritmético: F = A PLUS A
                        logic_result(i) := '0';
                        P_internal(i) <= '0';
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = 1 (ALL 1's)
                        logic_result(i) := '1';
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1101" => 
                    if M = '1' then -- Aritmético: F = (A OR B) PLUS A
                        logic_result(i) := A(i) or B(i);
                        P_internal(i) <= B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = A OR NOT B
                        logic_result(i) := A(i) or not B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1110" => 
                    if M = '1' then -- Aritmético: F = (A OR NOT B) PLUS A
                        logic_result(i) := A(i) or not B(i);
                        P_internal(i) <= not B(i);
                        G_internal(i) <= A(i);
                    else            -- Lógico: F = A OR B
                        logic_result(i) := A(i) or B(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when "1111" => 
                    if M = '1' then -- Aritmético: F = A MINUS 1
                        logic_result(i) := A(i);
                        P_internal(i) <= '1';
                        G_internal(i) <= '0';
                    else            -- Lógico: F = A
                        logic_result(i) := A(i);
                        P_internal(i) <= '0';
                        G_internal(i) <= '0';
                    end if;
                    
                when others => 
                    logic_result(i) := '0';
                    P_internal(i) <= '0';
                    G_internal(i) <= '0';
            end case;
        end loop;
        
        result <= logic_result;
    end process;
    
    -- Manejo de acarreo en modo aritmético
    process(M_sync, Cin, P_internal, G_internal)
    begin
        if M_sync = '1' then  -- Modo aritmético
            -- Cálculo del acarreo usando la estructura CLA (Carry Look-Ahead)
            Carry(0) <= not Cin;  -- Cin es activo en bajo
            
            for i in 0 to 3 loop
                Carry(i+1) <= G_internal(i) or (P_internal(i) and Carry(i));
            end loop;
            
            -- Propagar y Generar para toda la ALU
            P <= not (P_internal(0) and P_internal(1) and P_internal(2) and P_internal(3));
            G <= not (G_internal(3) or 
                     (P_internal(3) and G_internal(2)) or 
                     (P_internal(3) and P_internal(2) and G_internal(1)) or 
                     (P_internal(3) and P_internal(2) and P_internal(1) and G_internal(0)));
            
            -- Acarreo de salida (activo en bajo)
            Cout <= not Carry(4);
        else  -- Modo lógico
            -- En modo lógico, estas señales tienen valores específicos
            P <= '1';  -- Activo en bajo = inactivo
            G <= '1';  -- Activo en bajo = inactivo
            Cout <= '1';  -- Activo en bajo = inactivo
        end if;
    end process;
    
    -- Asignación de la salida
    F <= result;
    
    -- Detector de igualdad A=B
    AeqB <= '1' when result = "0000" and M = '1' and S = "1001" and Cin = '0' else '0';
    
end Behavioral;