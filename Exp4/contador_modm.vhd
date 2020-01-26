----------------------------------------------------------------
-- Arquivo   : contador_modm.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 19/01/2020
----------------------------------------------------------------
-- Descricao : contador binario modulo M
--             modulo M definido como generic
--             sinal de controle zera assincrono
--             descricao VHDL comportamental
--             numero de bits N do contador definido em funcao
--                do modulo do contador M
--                N=natural(ceil(log2(real(M))))
----------------------------------------------------------------
-- Exemplo de uso: instanciacao de um contador modulo 123
--       CONT123: contador_modm generic map (M=>123)
--                              port map (clock=>clock ....
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/09/2019  1.0     Edson Midorikawa  criacao
--     19/01/2020  1.1     Edson Midorikawa  adaptacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity contador_modm is
    generic (
        constant M: integer := 10 -- valor default do modulo do contador
    );
   port (
        clock, zera, conta: in std_logic;
        Q: out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
        fim: out std_logic
   );
end contador_modm;

architecture contador_modm_arch of contador_modm is
  signal IQ: integer range 0 to M-1;
begin

  process (clock,zera,conta,IQ)
  begin
    if zera='1' then IQ <= 0;
    elsif clock'event and clock='1' then
      if conta='1' then
        if IQ=M-1 then IQ <= 0;
        else IQ <= IQ + 1;
        end if;
      end if;
    end if;

    if IQ=M-1 then fim <= '1';
    else fim <= '0';
    end if;

    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

  end process;
end contador_modm_arch;
