
    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity ULA is
       generic (larguraDados : natural := 32);
       port(
          inputA          : in  std_logic_vector(larguraDados-1 downto 0);
          inputB          : in  std_logic_vector(larguraDados-1 downto 0);
          operacao        : in  std_logic_vector(1 downto 0);
          inverteB        : in  std_logic;
          output          : out std_logic_vector(larguraDados-1 downto 0);
          resultado_adder : out std_logic;
          flagZero        : out std_logic
       );
    end entity;

    architecture componente of ULA is

       signal carryInInverteB, SLT : std_logic;
       signal carryIn0,  carryIn1,  carryIn2,  carryIn3  : std_logic;
       signal carryIn4,  carryIn5,  carryIn6,  carryIn7  : std_logic; 
       signal carryIn8,  carryIn9,  carryIn10, carryIn11 : std_logic;
       signal carryIn12, carryIn13, carryIn14, carryIn15 : std_logic;
       signal carryIn16, carryIn17, carryIn18, carryIn19 : std_logic;
       signal carryIn20, carryIn21, carryIn22, carryIn23 : std_logic;
       signal carryIn24, carryIn25, carryIn26, carryIn27 : std_logic;
       signal carryIn28, carryIn29, carryIn30, carryIn31 : std_logic;
       signal carryOut31                                 : std_logic;
       constant zero: std_logic_vector(larguraDados-1 downto 0) := (others => '0');

    begin

    carryInInverteB <= inverteB;
    flagZero        <= '1' when unsigned(output) = unsigned(zero) else '0';
    SLT             <= (carryIn31 xor carryOut31) xor resultado_adder;
    
    ULINHA0: entity work.Ulinha
       port map(
          inputA          => inputA(0),
          inputB          => inputB(0),
          inverteB        => inverteB,
          SLT             => SLT,
          operacao        => operacao,
          carryIn         => carryInInverteB,
          carryOut        => carryIn1,
          saida           => output(0)
       );
    
    ULINHA1: entity work.Ulinha
       port map(
          inputA          => inputA(1),
          inputB          => inputB(1),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn1,
          carryOut        => carryIn2,
          saida           => output(1)
       );
    
    ULINHA2: entity work.Ulinha
       port map(
          inputA          => inputA(2),
          inputB          => inputB(2),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn2,
          carryOut        => carryIn3,
          saida           => output(2)
       );
    
    ULINHA3: entity work.Ulinha
       port map(
          inputA          => inputA(3),
          inputB          => inputB(3),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn3,
          carryOut        => carryIn4,
          saida           => output(3)
       );
    
    ULINHA4: entity work.Ulinha
       port map(
          inputA          => inputA(4),
          inputB          => inputB(4),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn4,
          carryOut        => carryIn5,
          saida           => output(4)
       );
    
    ULINHA5: entity work.Ulinha
       port map(
          inputA          => inputA(5),
          inputB          => inputB(5),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn5,
          carryOut        => carryIn6,
          saida           => output(5)
       );
    
    ULINHA6: entity work.Ulinha
       port map(
          inputA          => inputA(6),
          inputB          => inputB(6),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn6,
          carryOut        => carryIn7,
          saida           => output(6)
       );
    
    ULINHA7: entity work.Ulinha
       port map(
          inputA          => inputA(7),
          inputB          => inputB(7),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn7,
          carryOut        => carryIn8,
          saida           => output(7)
       );
    
    ULINHA8: entity work.Ulinha
       port map(
          inputA          => inputA(8),
          inputB          => inputB(8),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn8,
          carryOut        => carryIn9,
          saida           => output(8)
       );
    
    ULINHA9: entity work.Ulinha
       port map(
          inputA          => inputA(9),
          inputB          => inputB(9),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn9,
          carryOut        => carryIn10,
          saida           => output(9)
       );
    
    ULINHA10: entity work.Ulinha
       port map(
          inputA          => inputA(10),
          inputB          => inputB(10),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn10,
          carryOut        => carryIn11,
          saida           => output(10)
       );
    
    ULINHA11: entity work.Ulinha
       port map(
          inputA          => inputA(11),
          inputB          => inputB(11),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn11,
          carryOut        => carryIn12,
          saida           => output(11)
       );
    
    ULINHA12: entity work.Ulinha
       port map(
          inputA          => inputA(12),
          inputB          => inputB(12),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn12,
          carryOut        => carryIn13,
          saida           => output(12)
       );
    
    ULINHA13: entity work.Ulinha
       port map(
          inputA          => inputA(13),
          inputB          => inputB(13),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn13,
          carryOut        => carryIn14,
          saida           => output(13)
       );
    
    ULINHA14: entity work.Ulinha
       port map(
          inputA          => inputA(14),
          inputB          => inputB(14),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn14,
          carryOut        => carryIn15,
          saida           => output(14)
       );
    
    ULINHA15: entity work.Ulinha
       port map(
          inputA          => inputA(15),
          inputB          => inputB(15),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn15,
          carryOut        => carryIn16,
          saida           => output(15)
       );
    
    ULINHA16: entity work.Ulinha
       port map(
          inputA          => inputA(16),
          inputB          => inputB(16),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn16,
          carryOut        => carryIn17,
          saida           => output(16)
       );
    
    ULINHA17: entity work.Ulinha
       port map(
          inputA          => inputA(17),
          inputB          => inputB(17),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn17,
          carryOut        => carryIn18,
          saida           => output(17)
       );
    
    ULINHA18: entity work.Ulinha
       port map(
          inputA          => inputA(18),
          inputB          => inputB(18),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn18,
          carryOut        => carryIn19,
          saida           => output(18)
       );
    
    ULINHA19: entity work.Ulinha
       port map(
          inputA          => inputA(19),
          inputB          => inputB(19),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn19,
          carryOut        => carryIn20,
          saida           => output(19)
       );
    
    ULINHA20: entity work.Ulinha
       port map(
          inputA          => inputA(20),
          inputB          => inputB(20),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn20,
          carryOut        => carryIn21,
          saida           => output(20)
       );
    
    ULINHA21: entity work.Ulinha
       port map(
          inputA          => inputA(21),
          inputB          => inputB(21),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn21,
          carryOut        => carryIn22,
          saida           => output(21)
       );
    
    ULINHA22: entity work.Ulinha
       port map(
          inputA          => inputA(22),
          inputB          => inputB(22),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn22,
          carryOut        => carryIn23,
          saida           => output(22)
       );
    
    ULINHA23: entity work.Ulinha
       port map(
          inputA          => inputA(23),
          inputB          => inputB(23),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn23,
          carryOut        => carryIn24,
          saida           => output(23)
       );
    
    ULINHA24: entity work.Ulinha
       port map(
          inputA          => inputA(24),
          inputB          => inputB(24),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn24,
          carryOut        => carryIn25,
          saida           => output(24)
       );
    
    ULINHA25: entity work.Ulinha
       port map(
          inputA          => inputA(25),
          inputB          => inputB(25),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn25,
          carryOut        => carryIn26,
          saida           => output(25)
       );
    
    ULINHA26: entity work.Ulinha
       port map(
          inputA          => inputA(26),
          inputB          => inputB(26),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn26,
          carryOut        => carryIn27,
          saida           => output(26)
       );
    
    ULINHA27: entity work.Ulinha
       port map(
          inputA          => inputA(27),
          inputB          => inputB(27),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn27,
          carryOut        => carryIn28,
          saida           => output(27)
       );
    
    ULINHA28: entity work.Ulinha
       port map(
          inputA          => inputA(28),
          inputB          => inputB(28),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn28,
          carryOut        => carryIn29,
          saida           => output(28)
       );
    
    ULINHA29: entity work.Ulinha
       port map(
          inputA          => inputA(29),
          inputB          => inputB(29),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn29,
          carryOut        => carryIn30,
          saida           => output(29)
       );
    
    ULINHA30: entity work.Ulinha
       port map(
          inputA          => inputA(30),
          inputB          => inputB(30),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn30,
          carryOut        => carryIn31,
          saida           => output(30)
       );
    
    ULINHA31: entity work.Ula_overflow
       port map(
          inputA          => inputA(31),
          inputB          => inputB(31),
          inverteB        => inverteB,
          SLT             => '0',
          operacao        => operacao,
          carryIn         => carryIn31,
          carryOut        => carryOut31,
          saida           => output(31),
          resultado_adder => resultado_adder
       );
    end architecture;
