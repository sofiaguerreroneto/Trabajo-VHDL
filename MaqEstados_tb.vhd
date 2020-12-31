library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MaqEstados_tb is
--  Port ( );
end MaqEstados_tb;
architecture Behavioral of MaqEstados_tb is
    component MaqEstados
    port(
        boton	:IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Botones en cada piso
        clk,start	:IN STD_LOGIC; -- Boton de arranque   
        presencia	:IN STD_LOGIC; -- Sensores 
        alarm3	:IN STD_LOGIC; -- Botón de alarma
        abrir_m	:IN STD_LOGIC; -- Apertura y cierre
        puerta_a,puerta_c,motor_subir,motor_bajar	:OUT STD_LOGIC; -- Motor y puerta 
        display1,display2,display3,display4 :OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Vectores de displays de 9 segmentos (teniendo en cuenta que el 'punto' es otro segmento
    );
    end component;
    --IN
    signal clk : std_logic := '0';
    signal boton : std_logic_vector(3 downto 0) := (others => '0');
    signal start : std_logic := '0';
    signal presencia : std_logic := '0';
    signal alarm : std_logic := '0';
    signal abrir_m : std_logic := '0';
     --OUT
    signal display1 : std_logic_vector(7 downto 0);
    signal display2 : std_logic_vector(7 downto 0);
    signal display3 : std_logic_vector(7 downto 0);
    signal display4 : std_logic_vector(7 downto 0);
    signal puerta_a: std_logic;
    signal puerta_c: std_logic;
    signal motor_subir: std_logic;
    signal motor_bajar: std_logic;
    constant clk_period : time := 10 ns;
begin
      uut: MaqEstados PORT MAP (
          clk => clk,
          start => start,
          presencia => presencia,
          alarm3 => alarm,
          boton => boton,
          abrir_m =>abrir_m,
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4,
          puerta_a => puerta_a,
          puerta_c => puerta_c,
          motor_subir => motor_subir,
          motor_bajar => motor_bajar
        );
        clk_process :process
             begin
		      clk <= '0';
		     wait for clk_period/2;
	              clk <= '1';
		     wait for clk_period/2;
        end process;
	-- El 'clk' comienza en cero y tras 5ns pasa a ser 1, realizando un bucle continuo		     
			     
        ME_process: process
            begin
                wait for 50 ns;
                    start <= '1'; -- Iniciamos el programa
                wait for 50 ns;
                    start <= '0';
                wait for 5 us;
                    boton <= "1000"; -- Le decimos que vaya al piso 4  
                wait for 200 ns;
                    presencia<='1'; -- Antes de que se cierre la puerta, decimos que hay presencia para ver que se deje de cerrar la puerta
                wait for 2 us;
                    presencia<='0'; --Deja de haber presencia y se cierra la puerta para subir
                wait for 4 us;
                    boton <= "0010";-- Le decimos que vaya al piso 2 
                wait for 5 us;  
                    alarm <= '1'; -- Activamos la alarma
            wait;
        -- Tras 50ns 'start' pasa a ser 1, y tras otros 50ns, 0. Tras todo este recorrido más 5microsegundos el vector 'boton' pasa a ser 1000.
	-- Después de 200ns 'presencia' pasa a valer 1 y, trás 2microsegundos, 0.
	-- Finalmente y de nuevo después de todo este tiempo más 4microsegundos el 'boton' pasa a valer 0010. Después de otros 5microsegundos 'alarm' pasa a 1.

        end process;
     end Behavioral;
