library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TOP_tb is
--  Port ( );
end TOP_tb;
architecture Behavioral of TOP_tb is
COMPONENT Ascensor
    PORT(
    boton	:IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Botones en cada piso 
    clk,start	:IN STD_LOGIC; -- Boton de arranque
    presencia	:IN STD_LOGIC; --Sensores  ,abierto,cerrado
    alarm	:IN STD_LOGIC; --Botón de alarma
    abrir_m	:IN STD_LOGIC; --Apertura y cierre
    puerta_a,puerta_c,motor_subir,motor_bajar	:OUT STD_LOGIC; --Motor y puerta 
    alarma	:OUT STD_LOGIC; -- Luz emergencia 
    salida_final : out  STD_LOGIC_VECTOR (7 downto 0);
    control_salida : out  STD_LOGIC_VECTOR (3 downto 0)
        );
end component;
        signal presencia : std_logic := '0';
        signal clk : std_logic := '0';
        signal start : std_logic := '0';
        signal alarm : STD_LOGIC := '0'; --Botón de alarma
        signal boton : std_logic_vector(3 downto 0) := (others => '0');
        signal abrir_m	: STD_LOGIC := '0';
        signal puerta_a : STD_LOGIC := '0';
        signal puerta_c : std_logic := '1';
        signal motor_subir,motor_bajar	: STD_LOGIC := '0';
        signal salida_final : std_logic_vector(7 downto 0);
        signal control_salida : std_logic_vector(3 downto 0);
        signal alarma : std_logic := '0';
        constant clk_period : time := 10 ns;
begin
   uut: Ascensor PORT MAP (
        boton => boton,
	    clk => clk,
	    start =>start,
	    presencia => presencia,
	    alarm => alarm,
	    abrir_m => abrir_m,
	    puerta_a => puerta_a,
	    puerta_c => puerta_c,
	    motor_subir => motor_subir,
	    motor_bajar => motor_bajar,
	    alarma => alarma,
	    control_salida => control_salida,
	    salida_final => salida_final
        );
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   ME_process: process
            begin
                wait for 50 ns;
                start <= '1';
                wait for 50 ns;
                boton <= "1000";            
   end process;
end Behavioral;
