library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_74LS181_TB is
-- Testbench no tiene puertos
end ALU_74LS181_TB;

architecture Behavioral of ALU_74LS181_TB is
    -- Componente a probar
    component ALU_74LS181
        Port ( 
            A : in STD_LOGIC_VECTOR(3 downto 0);
            B : in STD_LOGIC_VECTOR(3 downto 0);
            S : in STD_LOGIC_VECTOR(3 downto 0);
            M : in STD_LOGIC;
            Cin : in STD_LOGIC;
            
            F : out STD_LOGIC_VECTOR(3 downto 0);
            AeqB : out STD_LOGIC;
            Cout : out STD_LOGIC;
            P : out STD_LOGIC;
            G : out STD_LOGIC
        );
    end component;
    
    -- Señales de entrada
    signal A_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal S_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal M_tb : STD_LOGIC := '0';
    signal Cin_tb : STD_LOGIC := '1';  -- Activo en bajo, inicialmente inactivo
    
    -- Señales de salida
    signal F_tb : STD_LOGIC_VECTOR(3 downto 0);
    signal AeqB_tb : STD_LOGIC;
    signal Cout_tb : STD_LOGIC;
    signal P_tb : STD_LOGIC;
    signal G_tb : STD_LOGIC;
    
    -- Constantes para el testbench
    constant CLK_PERIOD : time := 10 ns;
    
    -- Señal de reloj auxiliar para el testbench
    signal clk : std_logic := '0';
    
    -- Tipo y señal para la verificación de resultado esperado
    type test_case is record
        a, b : std_logic_vector(3 downto 0);
        s : std_logic_vector(3 downto 0);
        m : std_logic;
        cin : std_logic;
        expected_f : std_logic_vector(3 downto 0);
        expected_cout : std_logic;
        operation_name : string(1 to 20);  -- Nombre de la operación para mostrar
    end record;
    
    -- Array de casos de prueba
    type test_case_array is array (natural range <>) of test_case;
    
begin
    -- Instancia del componente a probar
    UUT: ALU_74LS181 port map (
        A => A_tb,
        B => B_tb,
        S => S_tb,
        M => M_tb,
        Cin => Cin_tb,
        F => F_tb,
        AeqB => AeqB_tb,
        Cout => Cout_tb,
        P => P_tb,
        G => G_tb
    );
    
    -- Generador de reloj
    process
    begin
        wait for CLK_PERIOD/2;
        clk <= not clk;
    end process;
    
    -- Proceso de estímulos
    process
        -- Definir casos de prueba para modo lógico (M=0)
        constant logic_test_cases : test_case_array := (
            -- A,   B,    S,     M, Cin, Expected F, Expected Cout, Operation Name
            (x"5", x"A", x"0", '0', '1', x"A",      '1',          "NOT A           "),
            (x"5", x"A", x"1", '0', '1', x"D",      '1',          "NOT (A AND B)   "),
            (x"5", x"A", x"2", '0', '1', x"8",      '1',          "NOT A AND B     "),
            (x"5", x"A", x"3", '0', '1', x"0",      '1',          "ZERO            "),
            (x"5", x"A", x"4", '0', '1', x"B",      '1',          "NOT A OR B      "),
            (x"5", x"A", x"5", '0', '1', x"C",      '1',          "NOT (A XOR B)   "),
            (x"5", x"A", x"6", '0', '1', x"F",      '1',          "A XOR B         "),
            (x"5", x"A", x"7", '0', '1', x"0",      '1',          "A AND B         "),
            (x"5", x"A", x"8", '0', '1', x"F",      '1',          "NOT A OR NOT B  "),
            (x"5", x"A", x"9", '0', '1', x"C",      '1',          "NOT (A XOR B)   "),
            (x"5", x"A", x"A", '0', '1', x"A",      '1',          "B               "),
            (x"5", x"A", x"B", '0', '1', x"F",      '1',          "A OR B          "),
            (x"5", x"A", x"C", '0', '1', x"F",      '1',          "ONE (ALL 1's)   "),
            (x"5", x"A", x"D", '0', '1', x"7",      '1',          "A OR NOT B      "),
            (x"5", x"A", x"E", '0', '1', x"F",      '1',          "A OR B          "),
            (x"5", x"A", x"F", '0', '1', x"5",      '1',          "A               ")
        );
        
        -- Definir casos de prueba para modo aritmético (M=1)
        constant arith_test_cases : test_case_array := (
            -- A,   B,    S,     M, Cin, Expected F, Expected Cout, Operation Name
            (x"5", x"A", x"0", '1', '0', x"5",      '1',          "A               "),
            (x"5", x"A", x"1", '1', '0', x"F",      '0',          "A OR B          "),
            (x"5", x"A", x"2", '1', '0', x"7",      '0',          "A OR NOT B      "),
            (x"5", x"A", x"3", '1', '0', x"F",      '0',          "MINUS 1 (ALL 1's)"),
            (x"5", x"A", x"4", '1', '0', x"1",      '1',          "A PLUS (A AND ~B)"),
            (x"5", x"A", x"6", '1', '0', x"F",      '0',          "A MINUS B MINUS 1"),
            (x"5", x"A", x"9", '1', '0', x"F",      '0',          "A PLUS B        "),
            (x"5", x"A", x"C", '1', '0', x"A",      '0',          "A PLUS A        "),
            (x"5", x"A", x"F", '1', '0', x"4",      '1',          "A MINUS 1       ")
        );
        
        variable current_case : test_case;
    begin
        -- Mensaje inicial
        report "-----------------------------------";
        report "  INICIO DE LAS PRUEBAS LÓGICAS";
        report "-----------------------------------";
        
        -- Pruebas de modo lógico
        for i in logic_test_cases'range loop
            current_case := logic_test_cases(i);
            
            A_tb <= current_case.a;
            B_tb <= current_case.b;
            S_tb <= current_case.s;
            M_tb <= current_case.m;
            Cin_tb <= current_case.cin;
            
            wait for CLK_PERIOD;
            
            -- Reporte de resultados
            report "Función: " & current_case.operation_name &
                   " | A=0x" & to_hstring(current_case.a) &
                   " B=0x" & to_hstring(current_case.b) &
                   " S=0x" & to_hstring(current_case.s) &
                   " M=" & std_logic'image(current_case.m) &
                   " Cin=" & std_logic'image(current_case.cin) &
                   " | F=0x" & to_hstring(F_tb) &
                   " (Expected: 0x" & to_hstring(current_case.expected_f) & ")";
                   
            -- Comprobación de resultados
            assert F_tb = current_case.expected_f
                report "ERROR EN LA FUNCIÓN LÓGICA: " & current_case.operation_name
                severity ERROR;
                
            wait for CLK_PERIOD;
        end loop;
        
        -- Mensaje intermedio
        report "-----------------------------------";
        report "  INICIO DE LAS PRUEBAS ARITMÉTICAS";
        report "-----------------------------------";
        
        -- Pruebas de modo aritmético
        for i in arith_test_cases'range loop
            current_case := arith_test_cases(i);
            
            A_tb <= current_case.a;
            B_tb <= current_case.b;
            S_tb <= current_case.s;
            M_tb <= current_case.m;
            Cin_tb <= current_case.cin;
            
            wait for CLK_PERIOD;
            
            -- Reporte de resultados
            report "Función: " & current_case.operation_name &
                   " | A=0x" & to_hstring(current_case.a) &
                   " B=0x" & to_hstring(current_case.b) &
                   " S=0x" & to_hstring(current_case.s) &
                   " M=" & std_logic'image(current_case.m) &
                   " Cin=" & std_logic'image(current_case.cin) &
                   " | F=0x" & to_hstring(F_tb) &
                   " Cout=" & std_logic'image(Cout_tb) &
                   " (Expected F: 0x" & to_hstring(current_case.expected_f) & 
                   ", Expected Cout: " & std_logic'image(current_case.expected_cout) & ")";
                   
            -- Comprobación de resultados
            assert F_tb = current_case.expected_f
                report "ERROR EN LA FUNCIÓN ARITMÉTICA: " & current_case.operation_name
                severity ERROR;
                
            wait for CLK_PERIOD;
        end loop;
        
        -- Caso especial: Prueba de igualdad (A=B)
        report "-----------------------------------";
        report "  PRUEBA DE IGUALDAD A=B";
        report "-----------------------------------";
        
        -- Caso 1: A = B
        A_tb <= x"5";
        B_tb <= x"5";
        S_tb <= x"9"; -- Operación A PLUS B
        M_tb <= '1';  -- Modo aritmético
        Cin_tb <= '0'; -- Acarreo activo
        
        wait for CLK_PERIOD;
        
        report "Prueba A=B: A=0x" & to_hstring(A_tb) &
               " B=0x" & to_hstring(B_tb) &
               " | AeqB=" & std_logic'image(AeqB_tb) &
               " (Expected: 1)";
               
        assert AeqB_tb = '1'
            report "ERROR en la prueba de igualdad A=B (debería ser 1)"
            severity ERROR;
            
        -- Caso 2: A ≠ B
        A_tb <= x"5";
        B_tb <= x"A";
        S_tb <= x"9"; -- Operación A PLUS B
        M_tb <= '1';  -- Modo aritmético
        Cin_tb <= '0'; -- Acarreo activo
        
        wait for CLK_PERIOD;
        
        report "Prueba A≠B: A=0x" & to_hstring(A_tb) &
               " B=0x" & to_hstring(B_tb) &
               " | AeqB=" & std_logic'image(AeqB_tb) &
               " (Expected: 0)";
               
        assert AeqB_tb = '0'
            report "ERROR en la prueba de igualdad A≠B (debería ser 0)"
            severity ERROR;
            
        -- Mensaje final
        report "-----------------------------------";
        report "    PRUEBAS COMPLETADAS";
        report "-----------------------------------";
        
        wait;
    end process;
    
end Behavioral;