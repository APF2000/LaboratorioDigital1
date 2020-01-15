----------------------------------------------------------------
-- Arquivo   : desafioExp2.vhdl
-- Projeto   : Desafio do Experimento 2
-- Data      : 14/01/2020
----------------------------------------------------------------
-- Descricao : Contador de 8 bits para display de 7 seg
--
-- entrada: hexa - codigo binario de 4 bits hexadecimal
-- saida:   sseg - codigo de 7 bits para display de 7 segmentos
----------------------------------------------------------------
-- dica de uso:
----------------------------------------------------------------
-- Revisoes  :
--     Data        T3B3  Alunos
--     14/01/2020          Lucas Lopes de Paula Junior 9344880
--                         Arthur Pires da Fonseca 10773096
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exp2_desafio is
      port (
            clockxp    :  in std_logic;
            zeraxp     :  in std_logic;
            contador :  in std_logic;
            display0 : out std_logic_vector(6 downto 0);
            display1 : out std_logic_vector(6 downto 0);
            rcoxp      : out std_logic;

            inicializador : in std_logic_vector(7 downto 0)
      );
end exp2_desafio;

architecture arch of exp2_desafio is

   component contador8bits is
   port (
        clock : in  std_logic;
        zera  : in  std_logic;
        conta : in  std_logic;
        Q     : out std_logic_vector (7 downto 0);
        rco   : out std_logic;

        init : in std_logic_vector(7 downto 0)
   );
   end component;

   component hexa7seg is
       port (
           hexa : in std_logic_vector(3 downto 0);
           sseg : out std_logic_vector(6 downto 0)
       );
   end component;

   signal menos, mais : std_logic_vector(3 downto 0);
   signal seg7_0, seg7_1 : std_logic_vector(6 downto 0);
   signal Qaux : std_logic_vector(7 downto 0);

begin

   Qaux(7 downto 4) <= mais;
   Qaux(3 downto 0) <= menos;

   cont8: contador8bits port map ( clock => clockxp,
												           zera => zeraxp,
                                   conta => contador,
												           Q => Qaux,
                                   rco => rcoxp,
                                   init => inicializador
                                 );

   hex7_0: hexa7seg port map ( hexa => menos,
                               sseg => seg7_0
                              );

   hex7_1: hexa7seg port map ( hexa => mais,
                               sseg => seg7_1
                              );

end architecture;
