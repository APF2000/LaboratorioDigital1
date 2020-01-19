----------------------------------------------------------------
-- Arquivo   : contador8bits.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 04/01/2020
----------------------------------------------------------------
-- Descricao : contador binario de 8 bits 
--             descricao VHDL estrutural 
--             similar ao cascateamento de 2 CIs 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     04/01/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador8bits is
   port (
        clock : in  std_logic;
        zera  : in  std_logic;
        conta : in  std_logic;
        Q     : out std_logic_vector (7 downto 0);
        rco   : out std_logic 
   );
end contador8bits;

architecture estrutural of contador8bits is

  component contador_163 
    port (
          clock    : in  std_logic;
          clr, ld  : in  std_logic;
          ent, enp : in  std_logic;
          D        : in  std_logic_vector (3 downto 0);
          Q        : out std_logic_vector (3 downto 0);
          rco      : out std_logic 
    );
  end component;

  signal s_rco : std_logic;
  signal s_Q   : std_logic_vector  (7 downto 0);
  
begin
  
  CONT1: contador_163 port map ( clock=>clock, 
                                 clr=>zera, 
                                 ld=>'1', 
                                 ent=>'1', 
                                 enp=>conta, 
                                 D=>"1111", 
                                 Q=>s_Q(3 downto 0), 
                                 rco=>s_rco
                               );
  
  CONT2: contador_163 port map ( clock=>clock, 
                                 clr=>zera, 
                                 ld=>'1', 
                                 ent=>s_rco, 
                                 enp=>conta, 
                                 D=>"1111", 
                                 Q=>s_Q(7 downto 4), 
                                 rco=>rco
                               );

  Q <= s_Q;

end estrutural;
