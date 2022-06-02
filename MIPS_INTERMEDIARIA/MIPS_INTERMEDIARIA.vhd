library ieee;
use ieee.std_logic_1164.all;

entity MIPS_INTERMEDIARIA is
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
          simulacao	         : boolean := TRUE	-- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	LEDR            : out std_logic_vector(9 downto 0);
   KEY             : in  std_logic_vector(3 downto 0);
	SW              : in  std_logic_vector(9 downto 0);
	HEX0,HEX1,HEX2  : out std_logic_vector(6 downto 0);
	HEX3,HEX4,HEX5  : out std_logic_vector(6 downto 0)
	-- Debug signals
	--ULA_DEBUG       : out std_logic_vector(larguraDados-1 downto 0);
	--PC_DEBUG        : out std_logic_vector(larguraDados-1 downto 0);
	--WE_DEBUG, RE_DEBUG  	: out std_logic;
	--BEQ_DEBUG, SelMuxJMP_DEBUG, AND_DBG : out std_logic;
	--INA_ULA_DBG, INB_ULA_DBG : out std_logic_vector(larguraDados-1 downto 0);
	--RS_DEBUG, RT_DEBUG, RD_DEBUG : out std_logic_vector(larguraAddrRegs-1 downto 0)
	--outBbancoREG_DBG, writeBancoC_DBG : out std_logic_vector(larguraDados-1 downto 0);
	--SelMuxRtImediato_DBG : out std_logic
	 

  );
end entity;


architecture arquitetura of MIPS_INTERMEDIARIA is
  -- CLK --
  signal CLK                  : std_logic;

  
  -- Pontos de Controle --
  signal Pontos_Controle      : std_logic_vector(8 downto 0);

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
  signal saidaSomadorImediato : std_logic_vector(larguraDados-1 downto 0);

  -- PC --
  signal saidaIncrementaPc    : std_logic_vector(larguraDados-1 downto 0);
  signal PC_Out               : std_logic_vector(larguraDados-1 downto 0);
  
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
  signal SelMuxPc             : std_logic;

  -- MUX Rt/Rd
  signal saidaMuxRtRd         : std_logic_vector (larguraAddrRegs-1 downto 0);
  signal SelMuxRtRd           : std_logic;

  -- MUX Rt/Imediato
  signal saidaMuxRtImediato   : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxRtImediato     : std_logic;

  -- MUX ULA/Mem
  signal saidaMuxULAMem       : std_logic_vector (larguraDados-1 downto 0);
  signal SelMuxULAMem         : std_logic;

  -- MUX Estende Sinal  
  signal saidaMuxEstendeSinal : std_logic_vector (larguraDados-1 downto 0);

  -- MUX Resultados  
  signal saidaMuxResultados   : std_logic_vector (larguraDados-1 downto 0);

  -- Alias --
  alias Opcode                : std_logic_vector (larguraOpcode-1 downto 0) is ROM_Out(31 downto 26);
  alias ImediatoJump          : std_logic_vector(larguraImediato-1 downto 0) is ROM_Out(25 downto 0);
  alias ImediatoRaw           : std_logic_vector(larguraImediatoRaw-1 downto 0) is ROM_Out(15 downto 0);
  alias Funct                 : std_logic_vector(larguraFunct-1 downto 0) is ROM_Out(5 downto 0);
  alias RegSAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(25 downto 21);
  alias RegTAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(20 downto 16);
  alias RegDAddr              : std_logic_vector (larguraAddrRegs-1 downto 0) is ROM_Out(15 downto 11);
begin

CLK <= KEY(0);

-- Instanciando os componentes:
-- ===== ULA =======:
MUX_UlaCtrl:  entity work.muxGenerico2x1  generic map (larguraDados => larguraUlaCtrl)
        port map( entradaA_MUX => decoderULAOpcodeOut,
                  entradaB_MUX =>  decoderULAFunctOut,
                  seletor_MUX  => ULAop,
                  saida_MUX    => ULAcrtl);

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

-- ===== Program Counter =======:
PC : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
        port map (DIN => saidaMuxPc, DOUT => PC_Out, ENABLE => '1', CLK => CLK, RST => '0');

-- ===== Incrementa Program Counter =======:
incrementaPC :  entity work.somaConstante generic map (larguraDados => larguraDados, constante => cteIncrementaPC)
        port map(entrada => PC_Out, saida => saidaIncrementaPc);

-- ===== Decoder =======:
decoder : entity work.decoderGenerico
        port map (Opcode => Opcode, Output => Pontos_Controle);

-- -- ===== Shift Left Jump =======:
-- shiftLeftJump : entity work.ShiftLeftJump generic map (larguraDados => larguraImediatoJump)
--         port map (DataInput => ROM_Out(25 downto 0), DataOutput => imediatoComShiftJump);

-- -- ===== Shift Left Imediato =======:
-- shiftLeftImediato: entity work.ShiftLeftImediato generic map (larguraDados => larguraDados)
--         port map (DataInput => sinalExtendido, DataOutput => imediatoComShift);

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
          port map (estendeSinal_IN => ImediatoRaw, estendeSinal_OUT =>  sinalExtendido);

-- ========================= MUX ========================================:	
-- ===== MUX([PC+4, BEQ]/Jmp) =======:	
MUX_Prox_PC :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map(entradaA_MUX  => saidaMuxEstendeSinal,
                 entradaB_MUX  => imediatoShiftLeft,
                 seletor_MUX   => SelMuxPc,
                 saida_MUX     => saidaMuxPc);
					  
-- ===== MUX(Rt/Rd) =======:	
MUX_RtRd :  entity work.muxGenerico2x1  generic map (larguraDados => larguraAddrRegs)
        port map( entradaA_MUX => RegTAddr,
                  entradaB_MUX => RegDAddr,
                  seletor_MUX  => SelMuxRtRd,
                  saida_MUX    => saidaMuxRtRd);
					  
-- ===== MUX(Rt/Imediato) =======:	
MUX_RtImediato :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Regt_ULA_B,
                 entradaB_MUX  =>  sinalExtendido,
                 seletor_MUX   => SelMuxRtImediato,
                 saida_MUX     => saidaMuxRtImediato);

-- ===== MUX(Mostrar PC e ULA nos HEX) =======:	
MUX_Resultados :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => PC_Out,
                 entradaB_MUX  => ULA_Out,
                 seletor_MUX   => SW(0),
                 saida_MUX     => saidaMuxResultados);
					  
-- ===== MUX(ULA/memoria) =======:	
MUX_ULAMemoria :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => ULA_Out,
                 entradaB_MUX  => RAM_Out,
                 seletor_MUX   => SelMuxULAMem,
                 saida_MUX     => saidaMuxULAMem);
					  
-- ===== MUX(Estende Sinal) =======:	
MUX_EstendeSinal :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => saidaIncrementaPc,
                 entradaB_MUX  => saidaSomadorImediato,
                 seletor_MUX   => saidaAnd,
                 saida_MUX     => saidaMuxEstendeSinal);
-- ========================= MUX ========================================				 

monitor: work.debugMonitor
      port map(PC        => PC_Out,
            Instrucao    => ROM_Out,
            LeituraRS    => Regs_ULA_A,
            LeituraRT    => Regt_ULA_B,
            EscritaRD    => saidaMuxULAMem,
            EntradaB_ULA => saidaMuxRtImediato,
            imediatoEstendido => sinalExtendido,
            saidaULA          => ULA_Out,
            dadoLido_RAM      => RAM_Out,
            proxPC            => saidaIncrementaPc,
            MUXProxPCEntradaA => saidaMuxEstendeSinal,
            MUXProxPCEntradaB => imediatoShiftLeft,
            ULActrl           => '0' & ULAcrtl,
            zeroFLAG          => flagZero,
            escreveC          => habEscritaReg,
            MUXPCBEQJUMP      => saidaAnd,
            MUXRTRD           => SelMuxRtRd,
            MUXRTIMED         => SelMuxRtImediato,
            MUXULAMEM         => SelMuxULAMem,
            iBEQ              => Pontos_Controle(6),
            WR                => habEscritaMEM,
            RD                => habLeituraMEM,
            --Output
            clkTCL 				=> open);


-- Shift left Imediato e Jump
extendidoShiftLeft(31 downto 2) <= sinalExtendido(29 downto 0);
extendidoShiftLeft(1 downto 0)  <= "00";

imediatoShiftLeft(31 downto 28) <= saidaIncrementaPc(31 downto 28);
imediatoShiftLeft(27 downto 2)  <= ImediatoJump(25 downto 0);
imediatoShiftLeft(1 downto 0)   <= "00";

-- Instanciando os pontos de controle:
SelMuxPc         <= Pontos_Controle(0);
SelMuxRtRd       <= Pontos_Controle(1);
habEscritaReg    <= Pontos_Controle(2);
SelMuxRtImediato <= Pontos_Controle(3);
ULAop            <= Pontos_Controle(4);
SelMuxULAMem     <= Pontos_Controle(5);
saidaAnd         <= flagZero and Pontos_Controle(6);
habLeituraMEM    <= Pontos_Controle(7);
habEscritaMEM    <= Pontos_Controle(8);

-- Testes
--ULA_DEBUG <= ULA_Out;
--PC_DEBUG  <= PC_Out;
--RE_DEBUG  <= habLeituraMEM;
--WE_DEBUG  <= habEscritaMEM;
--BEQ_DEBUG <= Pontos_Controle(6);
--SelMuxJMP_DEBUG <= Pontos_Controle(0);
--INA_ULA_DBG <= Regs_ULA_A;
--INB_ULA_DBG <= saidaMuxRtImediato;
--AND_DBG     <= saidaAnd;
--RS_DEBUG    <= RegSAddr;
--RT_DEBUG    <= RegTAddr;
--RD_DEBUG    <= RegDAddr;
--outBbancoREG_DBG <= Regt_ULA_B;
--SelMuxRtImediato_DBG <= SelMuxRtImediato;
--writeBancoC_DBG      <= saidaMuxULAMem;
							 
end architecture;