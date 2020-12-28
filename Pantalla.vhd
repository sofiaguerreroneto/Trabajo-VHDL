library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Pantalla is
  Port ( 
  estado : in natural;
  clk : in std_logic;
  cerrado1: in std_logic;
  abierto1: in std_logic;
  presencia1 : in std_logic;
  abrir_m1 : in std_logic;
  puerta_aaux1: in std_logic;
  puerta_caux1: in std_logic;
  motor_saux : in std_logic;
  motor_baux : in std_logic;
  piso : in std_logic_vector(3 downto 0);
  display1 : out std_logic_vector(7 downto 0);
  display2 : out std_logic_vector(7 downto 0);
  display3 : out std_logic_vector(7 downto 0);
  display4 : out std_logic_vector(7 downto 0)
  );
end Pantalla;
architecture Behavioral of Pantalla is
begin
displays: process(clk) -- Modificamos lo que muestra el display en función del estado en el que nos encontremos.
--Los estados toman el numero correspondiente con su puesto en la declaracion realizada en la Maquina de Estados por ejemplo si parado es el tercero en la lista tomara el numero 3.
	begin
		if clk 'event and clk='1' then
		case estado is--Comprueba en que estado estamos, los estados se han asignado mediante numeros para facilitar el codigo.
		  when 17|4|5|6|7|2=>
--En funcion de como se encuentre la puerta del ascensor coloca la letra que debe enseñar el display correspondiente.
		      if cerrado1='1' then
		            display1<= "11000110"; --C  
		            end if;
		      if abierto1='1'  then
		            display1<= "10001000"; --A
                    end if;
              if (presencia1='1' or abrir_m1 = '1') and puerta_aaux1='0' then
                display1<= "10001000"; --A
                    end if;
		      if ((puerta_aaux1='1'and abierto1='0') or (puerta_caux1='1' and cerrado1='0'))  then
		            display1<= "01111111"; --7f           
		      end if;
          when 16 =>
                   display2<= "01111111";  --7f
              if abierto1 = '1' then
                   display1<= "10001000"; --A
              else
                   display1<= "01111111"; --7f
              end if;
		  when 8|9|10|11 =>
--En funcion de como se encuentre el coloca la letra que debe enseñar el display correspondiente.
		  if motor_saux='1'  then
		         display2<= "10010010"; --S
		         end if;		       
		  when 12|13|14|15=>
		  if motor_baux='1'  then
		         display2<= "10000011"; --B
		         end if;       
		  when 3=>
		          display2<= "01111111"; 
		          display1<= "10001000"; --A
		  when 1 => 
		          display1<= "10001000"; --A
		          display2<= "01111111";
		  when others=>
		         display1<= "01111111"; 
		         display2<= "01111111"; 
		end case;
		case piso is
--Se comprueba en que piso esta el ascensor para mostrarlo a traves del display.
		  when "0001"=>
		      display3<= "11000000"; --0
		      display4<= "11111001"; --1
		  when "0010"=>
		      display3<= "11000000"; --0
		      display4<= "10100100"; --2
		  when "0100"=>
		      display3<= "11000000"; --0
		      display4<= "10110000"; --3
		  when "1000"=>
		      display3<= "11000000"; --0
		      display4<= "10011001"; --4
		   when others=>
		      display3<= "11000000";--0 
		      display4<= "10000001";--0 
	   end case;
		end if;
	end process; 

end Behavioral;
