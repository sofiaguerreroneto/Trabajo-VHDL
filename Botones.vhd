library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Botones is
  Port ( 
        clk : in std_logic;
        alarm3: in std_logic;
        boton: in std_logic_vector(3 downto 0);
        bot_ant: in std_logic_vector(3 downto 0);
        piso: in std_logic_vector(3 downto 0);
        presente : in natural;
        bot11,bot12,bot13,bot14 : inout std_logic_vector(3 downto 0);
        bot1,bot2,bot3,bot4: out std_logic_vector(3 downto 0);
        bandera: out std_logic
  );
end Botones;
architecture Behavioral of Botones is
TYPE estados2 IS (subiendo,bajando); 
SIGNAL direccion: estados2:=subiendo;
begin
ControlBotones : PROCESS(clk)
    begin
        if clk='1' and clk'event then
--Nuevamente los estados se sustituyen por numeros para facilitar el funcionamiento del codigo.
--Los estados toman el numero correspondiente con su puesto en la declaracion realizada en la Maquina de Estados por ejemplo si parado es el tercero en la lista tomara el numero 3.
         if (presente /= 1 and presente /=2) and alarm3='0' then
--Se comprueba el valor que se le da a la entrada boton y en funcion de ello se almacena su valor en una señal auxiliar correspondiente a dicho piso.
                    if(boton="0001") then
                        bot11<=boton;
                    end if;
                    if(boton="0010") then
                        bot12<=boton;
                    end if;
                    if(boton="0100") then
                        bot13<=boton;
                    end if;
                    if(boton="1000") then
                        bot14<=boton;
                    end if;
            end if;
            if (presente = 1) then --Cuando estamos en el estado inicial colocamos todas las señales a 0.
                    bot1<="0000";   bot2<="0000";    bot3<="0000";    bot4<="0000";
                    bot11<="0000";    bot12<="0000"; bot13<="0000";   bot14<="0000";
            end if;           
             if (presente = 3) then --Cuando esta parado comprueba el valor guardado en la señal bot ant para asi borrar las señales correspondientes al boton de dicho piso y evitar que se generen fallos.                        
                    if(bot_ant="0001") then
                        bandera<='0'; 
                        bot1<="0000";    bot11<="0000";                
                    end if;
                    if(bot_ant="0010") then
                        bandera<='0'; 
                        bot2<="0000";     bot12<="0000";                   
                    end if; 
                    if(bot_ant="0100") then
                        bandera<='0'; 
                        bot3<="0000";  bot13<="0000";                 
                    end if; 
                    if(bot_ant="1000") then
                        bandera<='0'; 
                        bot4<="0000"; bot14<="0000";                
                    end if;
                end if;                
                case direccion is --Comprueba la direccion en la que se encuentra el ascensor
                    when subiendo=>
 --Va comprobando todas las combinaciones posibles que se puedan presentar mientras el ascensor sube y va realizando los cambios que vayan siendo necesarios.
 --Ademas va actualizando la direccion que posee el ascensor.
                        if(	bot11="0000")and(bot12="0000")and(bot13="0000")and(bot14="0000")and(piso="0001")and(alarm3/='1')then
                            bandera<='1';
                        elsif(bot12>bot_ant) and (alarm3/='1') then
                            bot2<=bot12;
                            direccion<=subiendo;
                        elsif(bot13>bot_ant) and (bot_ant="0010") and (alarm3/='1') then
                            bot3<=bot13; 
                            direccion<=subiendo;
                        elsif(bot14>bot_ant) and (bot_ant="0100") and (alarm3/='1') then
                            bot4<=bot14; 
                            direccion<=bajando;
                        elsif((bot11/="0000")or(bot12/="0000"))	and	((bot13="0000")	and	(bot14="0000")	and (bot_ant="0100")) and (alarm3/='1') then --Partiendo de 3 para ir a 1 o 2
                            if((bot12/="0000")) and (bot11="0000") then --Al 2
                                 bot2<="0010";
                                 direccion<=bajando; 
                            elsif((bot11/="0000")) and (bot12="0000") then --Al 1
                                 bot1<="0001";
                                 direccion<=subiendo; 
                            elsif((bot12/="0000")) and (bot11/="0000") then -- Si has dado a los dos te deja en el mas cercano
                                 bot2<="0010";
                                 direccion<=bajando;
                            end if;
                        elsif((bot11/="0000")) and (bot12="0000") and (bot13="0000") and (bot14="0000") and (bot_ant="0010") and (alarm3/='1') then --De 2 a 1
                                bot1<="0001";
                                direccion<=subiendo;
                        elsif((bot14/="0000")	or	(bot13/="0000"))and((bot12="0000")and	(bot11="0000")	and (bot_ant="0001")) and (alarm3/='1') then --Pulsas 3 o 4 estando en 1
                            if(bot14/="0000") and(bot13="0000") then --Al 4
                                bot4<="1000";
                                direccion<=bajando;
                            elsif(bot13/="0000") and (bot14="0000") then -- Al 3
                                bot3<="0100";
                                direccion<=subiendo;
                            elsif(bot13/="0000") and (bot14/="0000") then -- Si has dado a los dos te deja en el mas cercano
                                bot3<="0100";
                                direccion<=subiendo;
                            end if;
                        elsif((bot14/="0000"))	and	(bot11="0000")and	(bot12="0000")and	(bot13="0000")and (bot_ant="0010") and (alarm3/='1') then --Pulsas 4 desde 2
                            bot4<="1000";
                            direccion<=bajando;
                            end if;
                        if( (alarm3='1')) and (piso/="0001") then -- Se da la alarma y vas a la planta 1 si no estabas ya ahi
                            bot1<="0001"; bot2<="0000";   bot3<="0000";  bot4<="0000";                       
                            direccion<=subiendo;      
                        end if;
                        if(alarm3='1') and (piso="0001") then -- Se da la alarma y ya estas en la planta 1
                            bot1<="0000"; bot2<="0000"; bot3<="0000";   bot4<="0000";
                            direccion<=subiendo;       
                        end if; 
                  when bajando=>  
--Va comprobando todas las combinaciones posibles que se puedan presentar mientras el ascensor sube y va realizando los cambios que vayan siendo necesarios. 
--Ademas va actualizando la direccion que posee el ascensor.           
                    if(	bot11="0000")and	(bot12="0000")	and	(bot13="0000")	and	(bot14="0000")	and (piso="0001") and (alarm3/='1') then
                            bandera<='1';
                            direccion<=subiendo;
                    elsif(bot13<bot_ant) and (bot13/="0000") and (alarm3/='1') then      
                            bot3<=bot13; 
                            direccion<=bajando;
                    elsif(bot12<bot_ant)  and  (bot12/="0000")  and  (bot_ant="0100") and (alarm3/='1') then
                            bot2<=bot12; 
                            direccion<=bajando;
                    elsif(bot11<bot_ant)  and  (bot11/="0000")  and  (bot_ant="0010") and (alarm3/='1') then
                            bot1<=bot11; 
                            direccion<=subiendo;
                    elsif((bot14/="0000")or(bot13/="0000"))	and	((bot11="0000")	and	(bot12="0000")	and (bot_ant="0010")) and (alarm3/='1') then
                            if((bot14/="0000")) and (bot13="0000") then 
                                bot4<="1000";
                                direccion<=bajando;
                            elsif((bot13/="0000")) and (bot14="0000") then
                                bot3<="0100";
                                direccion<=subiendo;
                            elsif((bot13/="0000")) and (bot14/="0000") then
                                bot3<="0100";
                                direccion<=subiendo;
                            end if;
                     elsif((bot14/="0000")) and (bot12="0000") and (bot11="0000") and (bot13="0000") and (bot_ant="0100") and (alarm3/='1') then       
                            bot4<="1000";
                            direccion<=bajando;
                     elsif((bot11/="0000")	or	(bot12/="0000"))and((bot13="0000")and	(bot14="0000")	and (bot_ant="1000")) and (alarm3/='1') then
                            if(bot12/="0000") and(bot11="0000") then 
                                bot2<="0010";
                                direccion<=bajando;
                            elsif(bot11/="0000") and (bot12="0000") then 
                                bot1<="0001";
                                direccion<=subiendo;
                            elsif(bot11/="0000") and(bot12/="0000") then 
                                bot2<="0010";
                                direccion<=bajando;
                            end if;
                     elsif((bot11/="0000"))	and	(bot14="0000")and	(bot12="0000")and	(bot13="0000")and (bot_ant="0100") and (piso/="0001") and (alarm3/='1') then
                            bot1<="0001";
                            direccion<=subiendo;
                     end if;
                     if( (alarm3='1')) and (piso/="0001") then
                        bot1<="0001";  bot2<="0000"; bot3<="0000";  bot4<="0000";
                        direccion<=subiendo;
                     end if;
                     if (alarm3='1') and (piso="0001") then
                        bot1<="0000";         bot2<="0000";      bot3<="0000";       bot4<="0000";
                    end if;
            end case;
        end if;
    end process;  
end Behavioral;
