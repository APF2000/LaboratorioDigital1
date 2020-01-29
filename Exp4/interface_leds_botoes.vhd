library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity interface_leds_botoes is
  port (
     clock, reset: in std_logic;
     iniciar, resposta: in std_logic;
     ligado, estimulo, pulso: out std_logic;
     erro, pronto: out std_logic;
	 estado : out std_logic_vector(3 downto 0);
	 contador : out std_logic_vector(3 downto 0)
 );
end interface_leds_botoes;

architecture arc of interface_leds_botoes is
  component latch_sr is
      port ( s, r: in  std_logic;
             q:    out std_logic
           );
  end component;

  component contador_modm is
      generic (
          constant M: integer := 10 -- valor default do modulo do contador
      );
     port (
          clock, zera, conta: in std_logic;
          Q: out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
          fim: out std_logic
     );
  end component;

  constant M: integer := 10;

  signal conta, respostaAux, estimuloAux, erroAux : std_logic;
  signal valorCont : std_logic_vector(3 downto 0);
  signal notResposta : std_logic;

  type tipo_Estado is (DESLIGADO, ATRASO, REACAO, REJEICAO, FIM);
  signal Ereg, Eprox: tipo_Estado;

begin

  nextState : process(Ereg, iniciar, valorCont, resposta)
  begin
    case Ereg is
       when DESLIGADO =>  if iniciar = '1' then   Eprox <= ATRASO;
                          else                    Eprox <= DESLIGADO;
                          end if;

       when ATRASO    =>  if resposta = '1' then  Eprox <= REJEICAO;
                          elsif reset = '1' then Eprox <= DESLIGADO;
                          elsif valorCont = "1001" then Eprox <= REACAO;
                          else                    Eprox <= ATRASO;
                          end if;

       when REACAO    =>  if resposta = '1' then  Eprox <= FIM;
                          elsif reset = '1' then Eprox <= DESLIGADO;
                          else                    Eprox <= REACAO;
                          end if;

       when REJEICAO      =>  if reset = '1' then Eprox <= DESLIGADO;
                          else Eprox <= FIM;
                          end if;

       when FIM       =>  if reset = '1' then Eprox <= DESLIGADO;
                          else Eprox <= FIM;
                          end if;

       when others =>  Eprox <= DESLIGADO;
    end case;
  end process nextState;

  main : process(clock, reset)
  begin

    if reset = '1' then
      ligado <= '0';
      Ereg <= DESLIGADO; --reset assíncrono
    elsif clock'event and clock = '1' then
      if iniciar = '1' then
        ligado <= '1';
      end if;
		Ereg <= Eprox;
    end if;
  end process main;


  counter : contador_modm port map (
    clock => clock,
    zera => reset,
    conta => conta,
    Q => valorCont,
    fim => open
  );

  notResposta <= not resposta;

  latch : latch_sr port map (
		s => resposta,
		r => notResposta,
		q => respostaAux
  );

  with Ereg select
     erroAux <= '1' when REJEICAO,
             '0' when others;
  with Ereg select
     estimuloAux  <= '1' when REACAO,
                  '0' when others;
  with Ereg select
     pronto <= '1' when FIM | REJEICAO,
               '0' when others;
  with Ereg select
     conta <= '1' when ATRASO,
              '0' when others;

  with Ereg select
	estado <= "0000" when DESLIGADO,
			"0001" when ATRASO,
			"0010" when REACAO,
			"0011" when FIM,
			"0100" when REJEICAO,
			"1111" when others;

	erro <= erroAux;
	contador <= valorCont;
	estimulo <= estimuloAux;
	pulso <= estimuloAux and (not respostaAux);
end arc;
