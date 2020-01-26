----------------------------------------------------------------
-- Arquivo   : latch_sr.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 20/01/2020
----------------------------------------------------------------
-- Descricao : latch SR 
--             descricao comportamental 
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     20/01/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity latch_sr is
    port ( s, r: in  std_logic;
           q:    out std_logic
         );
end latch_sr;

architecture comportamental of latch_sr is
  signal iq: std_logic;
begin

  process (s,r,iq)
  begin
    if r = '1' then iq <= '0';     -- reset
    elsif s = '1' then iq <= '1';  -- set
    else iq <= iq;
    end if;

    q <= iq;

  end process;



end comportamental;
