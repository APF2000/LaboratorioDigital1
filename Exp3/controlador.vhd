----------------------------------------------------------------
-- Arquivo   : controlador.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 09/01/2020
----------------------------------------------------------------
-- Descricao : controlador (unidade de controle)
--             do medidor do tempo de reacao (largura de pulso)
--             descricao VHDL comportamental
--
-- sinais de condicao: liga - aciona medida da largura
--                     sinal - pulso a ser medido
-- sinais de controle: zeraCont - zera contagem
--                     contaCont - habilita contagem
--                     pronto - indica final da medida
-----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/01/2020  1.0     Edson Midorikawa  criacao
-----------------------------------------------------------------
--
library IEEE;
use IEEE.std_logic_1164.all;

entity controlador is
   port ( clock, reset:        in  STD_LOGIC;
          liga, sinal:         in  STD_LOGIC;
          zeraCont, contaCont: out STD_LOGIC;
          pronto:              out STD_LOGIC;
          estado:              out STD_LOGIC_VECTOR(3 downto 0)
        );
end controlador;

architecture controlador_arch of controlador is
   type tipo_Estado is (INICIAL, LIGADO, CONTA, ESPERA, FIM);
   signal Ereg, Eprox: tipo_Estado;
begin

   -- mudanca de estado
   process (clock, reset)
   begin
      if reset = '1' then
         Ereg <= INICIAL;
      elsif clock'event and clock = '1' then
         Ereg <= Eprox;
      end if;
   end process;

   -- logica de proximo estado
   process (LIGA, SINAL, Ereg)
   begin
      case Ereg is
         when INICIAL =>  if LIGA = '0' then   Eprox <= INICIAL;
                          else                 Eprox <= LIGADO;
                          end if;

         when LIGADO =>   if SINAL = '0' then  Eprox <= LIGADO;
                          else                 Eprox <= CONTA;
                          end if;

         when CONTA =>    if SINAL = '1' then  Eprox <= CONTA;
                          else                 Eprox <= FIM;
                          end if;

         when FIM =>      Eprox <= ESPERA;

         when ESPERA =>   if LIGA = '0' then     Eprox <= INICIAL;
                          elsif SINAL = '0' then Eprox <= ESPERA;
                          else                   Eprox <= CONTA;
                          end if;

         when others =>  Eprox <= INICIAL;
      end case;
   end process;

   -- sinais de controle ativos em alto
   with Ereg select
      zeraCont  <= '1' when LIGADO | ESPERA,
                   '0' when others;
   with Ereg select
      contaCont <= '1' when CONTA,
                  '0' when others;
   with Ereg select
      pronto <= '1' when FIM,
                '0' when others;
   with Ereg select
      estado  <= "0000" when INICIAL,
                 "0001" when LIGADO,
                 "0010" when CONTA,
                 "0100" when FIM,
                 "1000" when ESPERA,
                 "1111" when others;
end controlador_arch;
