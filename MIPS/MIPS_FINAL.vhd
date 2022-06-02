library ieee;
use ieee.std_logic_1164.all;

entity MIPS_FINAL is
  -- Total de bits das entradas e saidas, constantes.
  generic (
          larguraDados        : natural := 32;
          larguraEnderecoRAM  : natural := 6;
          larguraAddrRegs     : natural := 5;
          larguraOpcode       : natural := 6;
          cteIncrementaPC     : natural := 4;
          larguraImediatoRaw  : natural := 16;
          larguraImediato     : natural := 26;
          larguraImediatoJump : natural := 26;
          larguraUlaCtrl      : natural := 3;
          larguraFunct        : natural := 6;
			 larguraDecoder      : natural := 13;
          simulacao	         : boolean := FALSE	-- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	LEDR            : out std_logic_vector(9 downto 0);
   KEY             : in  std_logic_vector(3 downto 0);
	SW              : in  std_logic_vector(9 downto 0);
	HEX0,HEX1,HEX2  : out std_logic_vector(6 downto 0);
	HEX3,HEX4,HEX5  : out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of MIPS_FINAL is
  -- CLK --
  signal CLK                  : std_logic;
  
  -- Pontos de Controle --
  signal Pontos_Controle         : std_logic_vector (larguraDecoder downto 0);
  signal BEQ_signal, BNE_signal  : std_logic;
  signal saidaMuxFlagZero        : std_logic;
  signal saidaOrBeqBne, ORI_ANDI : std_logic;
 
  -- ULA --
  signal Regt_ULA_B           : std_logic_vector (larguraDados-1 downto 0);
  signal Regs_ULA_A           : std_logic_vector (larguraDados-1 downto 0);
  signal ULA_Out              : std_logic_vector (larguraDados-1 downto 0);
  signal ULAop                : std_logic;
  signal decoderULAOpcodeOut  : std_logic_vector (larguraUlaCtrl-1 downto 0);
  signal decoderULAFunctOut   : std_logic_vector (larguraUlaCtrl-1 downto 0);
  signal ULAcrtl              : std_logic_vector (larguraUlaCtrl-1 downto 0);
  signal flagZero             : std_logic;

  -- Somador Generico --
  signal saidaSomadorImediato : std_logic_vector (larguraDados-1 downto 0);

  -- PC --
  signal saidaIncrementaPc    : std_logic_vector (larguraDados-1 downto 0);
  signal PC_Out               : std_logic_vector (larguraDados-1 downto 0);
  
  -- ROM, RAM e Registradores --
  signal RAM_Out              : std_logic_vector (larguraDados-1 downto 0);
  signal ROM_Out              : std_logic_vector (larguraDados-1 downto 0);
  signal habEscritaReg        : std_logic;
  signal habLeituraMEM        : std_logic;
  signal habEscritaMEM        : std_logic;

  -- Extensor de sinal --
  signal sinalExtendido       : std_logic_vector (larguraDados-1 downto 0);

  -- Shift Left --
  signal extendidoShiftLeft   : std_logic_vector (larguraDados-1 downto 0);
  signal imediatoShiftLeft    : std_logic_vector (larguraDados-1 downto 0);

  -- Porta Logica AND --
  signal saidaAnd             : std_logic;

  -- MUX --
  -- MUX PC
  signal saidaMuxPc           : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxPc 		      : std_logic;

  -- MUX JR 
  signal saidaMuxJR           : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxJR   				: std_logic;

  -- MUX Rt/Rd
  signal saidaMuxRtRd         : std_logic_vector (larguraAddrRegs-1 downto 0);
  signal SelMuxRtRd           : std_logic_vector(1 downto 0);

  -- MUX Rt/Imediato
  signal saidaMuxRtImediato   : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxRtImediato     : std_logic;

  -- MUX ULA/Mem
  signal saidaMuxULAMem       : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxULAMem         : std_logic_vector (1 downto 0);

  -- MUX Estende Sinal  
  signal saidaMuxEstendeSinal : std_logic_vector (larguraDados-1 downto 0);
  signal saidaLui             : std_logic_vector (larguraDados-1 downto 0);

  -- MUX Resultados  
  signal saidaMuxResultados   : std_logic_vector (larguraDados-1 downto 0);

  -- Alias --
  alias Opcode                : std_logic_vector (larguraOpcode-1 downto 0) is ROM_Out(31 downto 26);
  alias ImediatoJump          : std_logic_vector (larguraImediato-1 downto 0) is ROM_Out(25 downto 0);
  alias ImediatoRaw           : std_logic_vector (larguraImediatoRaw-1 downto 0) is ROM_Out(15 downto 0);
  alias Funct                 : std_logic_vector (larguraFunct-1 downto 0) is ROM_Out(5 downto 0);
  alias RegSAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(25 downto 21);
  alias RegTAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(20 downto 16);
  alias RegDAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(15 downto 11);
begin

CLK <= KEY(0);

-- Instanciando os componentes:
-- ========================= ULA ========================================
MUX_UlaCtrl:  entity work.muxGenerico2x1  generic map (larguraDados => larguraUlaCtrl)
        port map( entradaA_MUX => decoderULAOpcodeOut,
                  entradaB_MUX =>  decoderULAFunctOut,
                  seletor_MUX => ULAop,
                  saida_MUX => ULAcrtl);

decoderULAOpcode : entity work.decoderULAOpcode
	port map (Opcode => ROM_Out(31 downto 26), Output => decoderULAOpcodeOut);

decoderULAFunct : entity work.decoderULAFunct
        port map (Funct => Funct, Output => decoderULAFunctOut);

ULA : entity work.ULAMIPS  generic map(larguraDados => larguraDados)
          port map (
                inputA          => Regs_ULA_A,
                inputB          => saidaMuxRtImediato,
                operacao        => ULAcrtl(1 downto 0),
                inverteB        => ULAcrtl(2),
                output          => ULA_Out,
                flagZero        => flagZero
        );
-- ========================= ULA ========================================

-- ===== Program Counter =======:
PC : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
        port map (DIN => saidaMuxJR, DOUT => PC_Out, ENABLE => '1', CLK => CLK, RST => '0');

-- ===== Incrementa Program Counter =======:
incrementaPC :  entity work.somaConstante generic map (larguraDados => larguraDados, constante => cteIncrementaPC)
        port map(entrada => PC_Out, saida => saidaIncrementaPc);

-- ===== Decoder =======:
decoder : entity work.decoderGenerico
        port map (Funct => Funct, Opcode => Opcode, Output => Pontos_Controle);

-- ===== Somador =======:
somadorImediato :  entity work.somadorGenerico  generic map (larguraDados => larguraDados)
        port map( entradaA => saidaIncrementaPc, entradaB =>  extendidoShiftLeft, saida => saidaSomadorImediato);

-- ===== ROM =======:	
ROM : entity work.ROMMIPS   generic map (dataWidth => larguraDados, addrWidth => larguraDados)
        port map ( clk      => CLK,
		   Endereco => PC_Out, 
		   Dado     => ROM_Out);
		  
-- ===== RAM =======:	
RAMMIPS : entity work.RAMMIPS generic map (dataWidth => larguraDados, addrWidth => larguraDados, memoryAddrWidth => larguraEnderecoRAM)
        port map ( clk           => CLK,
                   Endereco      => ULA_Out,
                   Dado_in       => Regt_ULA_B,
                   Dado_out      => RAM_Out,
                   habEscritaMEM => habEscritaMEM,
                   habLeituraMEM => habLeituraMEM,
                   habilita      => '1');

-- ===== Banco de registradores =======:		  
bancoReg : entity work.bancoRegistradores   generic map (larguraDados => larguraDados, larguraEndBancoRegs => larguraAddrRegs)
          port map (  clk          => CLK,
                      enderecoA    => RegSAddr,
                      enderecoB    => RegTAddr,
                      enderecoC    => saidaMuxRtRd,
                      dadoEscritaC => saidaMuxULAMem,
                      escreveC     => habEscritaReg,
                      saidaA       => Regs_ULA_A,
                      saidaB       => Regt_ULA_B);

-- ===== Extensor de sinal =======:				 
estendeSinal : entity work.estendeSinalGenerico   generic map (larguraDadoEntrada => larguraImediatoRaw, larguraDadoSaida => larguraDados)
          port map (estendeSinal_IN => ImediatoRaw, ORI => ORI_ANDI, estendeSinal_OUT =>  sinalExtendido);
			 
-- ===== Extensor LUI =======:				 
LUI : entity work.LUI generic map (larguraDadoEntrada => larguraImediatoRaw, larguraDadoSaida => larguraDados)
				port map (estendeSinal_IN => ImediatoRaw, estendeSinal_OUT => saidaLui);


-- ========================= MUX ========================================:	
-- ===== MUX([PC+4, BEQ]/Jmp) =======:	
MUX_Prox_PC :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => saidaMuxEstendeSinal,
                 entradaB_MUX  =>  imediatoShiftLeft,
                 seletor_MUX   => SelMuxPc,
                 saida_MUX     => saidaMuxPc);
					  
-- ===== MUX(JR) =======:	
MUX_JR :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => saidaMuxPc,
                 entradaB_MUX  => Regs_ULA_A,
                 seletor_MUX   => SelMuxJR,
                 saida_MUX     => saidaMuxJR);

-- ===== MUX(Rt/Rd) =======:					  
MUX_RtRd: entity work.muxGenerico4x1  generic map (larguraDados => larguraAddrRegs)
		port map( 
			entradaA_MUX =>  RegTAddr,
			entradaB_MUX =>  RegDAddr,
			entradaC_MUX =>  "11111",
			entradaD_MUX =>  "00000",
			seletor_MUX  => SelMuxRtRd,
			saida_MUX    => saidaMuxRtRd);
					  					  
-- ===== MUX(Rt/Imediato) =======:	
MUX_RtImediato :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Regt_ULA_B,
                 entradaB_MUX  => sinalExtendido,
                 seletor_MUX   => SelMuxRtImediato,
                 saida_MUX     => saidaMuxRtImediato);

-- ===== MUX(Mostrar PC e ULA nos HEX) =======:	
MUX_Resultados :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => PC_Out,
                 entradaB_MUX  =>  ULA_Out,
                 seletor_MUX   => SW(0),
                 saida_MUX     => saidaMuxResultados);
					  
-- ===== MUX(ULA/memoria) =======:	
MUX_ULAMemoria: entity work.muxGenerico4x1  generic map (larguraDados => larguraDados)
		port map( 
			entradaA_MUX =>  ULA_Out,
			entradaB_MUX =>  RAM_Out,
			entradaC_MUX =>  saidaIncrementaPc,
			entradaD_MUX =>  saidaLui,
			seletor_MUX  =>  SelMuxULAMem,
			saida_MUX    =>  saidaMuxULAMem);

-- ===== MUX( FLAG ZERO ) =======:	
MUX_FlagZero :  entity work.muxGenerico2x1_1bit
        port map( inA_MUX   => not(flagZero),
						inB_MUX   => flagZero,
						sel_MUX   => BEQ_signal,
						saida_MUX => saidaMuxFlagZero);		

-- ===== MUX(Estende Sinal) =======:	
MUX_EstendeSinal :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => saidaIncrementaPc,
                 entradaB_MUX  => saidaSomadorImediato,
                 seletor_MUX   => saidaAnd,
                 saida_MUX     => saidaMuxEstendeSinal);
					  

-- ========================= MUX ========================================
-- ===== MONITOR =======	

monitor: work.debugMonitor
      port map(PC        		=> PC_Out,
            Instrucao    		=> ROM_Out,
            LeituraRS    		=> Regs_ULA_A,
            LeituraRT    		=> Regt_ULA_B,
            EscritaRD    		=> saidaMuxULAMem,
            EntradaB_ULA 		=> saidaMuxRtImediato,
            imediatoEstendido => sinalExtendido,
            saidaULA          => ULA_Out,
            dadoLido_RAM      => RAM_Out,
            proxPC            => saidaIncrementaPc,
            MUXProxPCEntradaA => saidaMuxEstendeSinal,
            MUXProxPCEntradaB => imediatoShiftLeft,
            ULActrl           => '0' & ULAcrtl,
            zeroFLAG          => flagZero,
            escreveC          => habEscritaReg,
            MUXPCBEQJUMP      => SelMuxPc,
				MUXPCBEQ          => saidaAnd,
            MUXRTRD           => SelMuxRtRd,
            MUXRTIMED         => SelMuxRtImediato,
            MUXULAMEM         => SelMuxULAMem,
            iBEQ              => Pontos_Controle(6),
            WR                => habEscritaMEM,
            RD                => habLeituraMEM,
            --Output
            clkTCL            => open);

-- ===== Decoders binarios para HEX =======:
decoder_binario0 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(3 downto 0), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX0);		 

decoder_binario1 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(7 downto 4), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX1);		 

decoder_binario2 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(11 downto 8), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX2);		 

decoder_binario3 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(15 downto 12), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX3);		 

decoder_binario4 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(19 downto 16), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX4);		 

decoder_binario5 : entity work.conversorHex7Seg 
          port map (dadoHex => saidaMuxResultados(23 downto 20), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX5);

-- PORTAS LOGICAS
saidaAnd         <= saidaMuxFlagZero and saidaOrBeqBne;
saidaOrBeqBne    <= BEQ_signal or BNE_signal;
			 
-- Shift left Imediato e Jump
extendidoShiftLeft(31 downto 2) <= sinalExtendido(29 downto 0);
extendidoShiftLeft(1 downto 0)  <= "00";

imediatoShiftLeft(31 downto 28) <= saidaIncrementaPc(31 downto 28);
imediatoShiftLeft(27 downto 2)  <= ImediatoJump(25 downto 0);
imediatoShiftLeft(1 downto 0)   <= "00";

-- Instanciando os pontos de controle:
SelMuxJR         <= Pontos_Controle(0);
SelMuxPc         <= Pontos_Controle(1);
SelMuxRtRd       <= Pontos_Controle(3 downto 2);
ORI_ANDI         <= Pontos_Controle(4);
habEscritaReg    <= Pontos_Controle(5);
SelMuxRtImediato <= Pontos_Controle(6);
ULAop            <= Pontos_Controle(7);
SelMuxULAMem     <= Pontos_Controle(9 downto 8);
BEQ_signal       <= Pontos_Controle(10);
BNE_signal       <= Pontos_Controle(11);
habLeituraMEM    <= Pontos_Controle(12);
habEscritaMEM    <= Pontos_Controle(13);

-- Instanciando LEDs para resultados
LEDR(7 downto 4) <= saidaMuxResultados(31 downto 28);
LEDR(3 downto 0) <= saidaMuxResultados(27 downto 24);

end architecture;