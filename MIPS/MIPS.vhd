library ieee;
use ieee.std_logic_1164.all;

entity MIPS is
-- Total de bits das entradas e saidas
	generic ( 
		dataWidth        : natural := 32;
		addrWidth        : natural := 32;
		
		regAddrWidth     : natural := 5;
		cteIncrementaPC  : natural := 4;
		
		ramMemoryAddrWidth : natural := 6;
	 	
		romQtdPositions  : natural := 6;
		simulacao        : boolean := TRUE; -- para gravar na placa, altere de TRUE para FALSE
		
		widthRawImediato : natural := 16
	);
	port   (
		CLOCK_50 : in std_logic;
		KEY      : in std_logic_vector(3 downto 0)
	);
end entity;


architecture arquitetura of MIPS is
	signal proxPc             : std_logic_vector (addrWidth-1 downto 0);
	signal romAddress         : std_logic_vector (addrWidth-1 downto 0);
	
	signal addressReg1        : std_logic_vector (regAddrWidth-1 downto 0);
	signal addressReg2        : std_logic_vector (regAddrWidth-1 downto 0);
	signal addressReg3        : std_logic_vector (regAddrWidth-1 downto 0);
	
	signal romInstruction     : std_logic_vector (dataWidth-1 downto 0);
	
	signal inputUlaA          : std_logic_vector (dataWidth-1 downto 0);
	signal inputUlaB          : std_logic_vector (dataWidth-1 downto 0);
	signal outUla             : std_logic_vector (dataWidth-1 downto 0);
	
	signal habRegPc           : std_logic;
	signal CLK                : std_logic;
	signal reg3WE             : std_logic;
	signal rstRegPC           : std_logic;
	signal weRamMips          : std_logic;
	
	-- RAM
	signal dataOutRam         : std_logic_vector (dataWidth-1 downto 0);
	signal dataInRam          : std_logic_vector (dataWidth-1 downto 0);
	
	signal inputUlaRamAddrA   : std_logic_vector (dataWidth-1 downto 0);
	signal inputUlaRamAddrB   : std_logic_vector (dataWidth-1 downto 0);
	signal ramAddr            : std_logic_vector (dataWidth-1 downto 0);


	alias  addrReg1           : std_logic_vector (4  downto 0) is romInstruction(25 downto 21);
	alias  addrReg2           : std_logic_vector (4  downto 0) is romInstruction(20 downto 16);
	alias  addrReg3           : std_logic_vector (4  downto 0) is romInstruction(20 downto 16);
	
	alias  imediato           : std_logic_vector (widthRawImediato-1 downto 0) is romInstruction(15 downto 0);
	signal imediatoExtendido  : std_logic_vector (dataWidth-1 downto 0);



begin
	-- Para simular, fica mais simples tirar o edgeDetector
	gravar:  if simulacao generate
		CLK <= KEY(0);
	else generate
		detectorSub0: work.edgeDetector(bordaSubida)

	port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
	end generate;


	regPc : entity work.registradorGenerico generic map (larguraDados => dataWidth)
	port map (
		DIN    => proxPc, 
		DOUT   => romAddress, 
		ENABLE => habRegPc, 
		CLK    => CLK,
		RST    => rstRegPC);
	
	ulaincrementaPc : entity work.somaConstante generic map (larguraDados => addrWidth, constante => cteIncrementaPC)		
	port map (
		entrada => romAddress,
		saida   => proxPc);

	romMips : entity work.romMips 
	generic map (
		dataWidth       => dataWidth,
		addrWidth       => addrWidth,
		memoryAddrWidth => romQtdPositions) -- romQtdPositions, ex 64: posicoes de 32 bits cada
		
	port map ( 
		clk      => CLK,
		Endereco => romAddress,
		Dado     => romInstruction);		
	
	bancoRegistradores : entity work.bancoRegistradores generic map(larguraDados => dataWidth, larguraEndBancoRegs => regAddrWidth)
			
	port map (
		clk             => CLK,
		--
		enderecoA       => addressReg1,
		enderecoB       => addressReg2,
		enderecoC       => addressReg3,
		--
		dadoEscritaC    => dataOutRam,
		--
		escreveC        => reg3WE,
		saidaA          => inputUlaA,
		saidaB          => dataInRam);

	extensorImediato : entity work.estendeSinalGenerico generic map (larguraDadoEntrada => widthRawImediato, larguraDadoSaida => dataWidth)
	port map (estendeSinal_IN => imediato, estendeSinal_OUT =>  imediatoExtendido);

	ulaAddrRAM : entity work.ULASomaSub generic map(larguraDados => dataWidth)
	port map (
		entradaA => inputUlaRamAddrA,
		entradaB => inputUlaRamAddrB,
		saida    => ramAddr,
		seletor  => '1');
		
	ramMips : entity work.ramMips
	generic map (
          dataWidth       => dataWidth,
          addrWidth       => addrWidth,
          memoryAddrWidth => ramMemoryAddrWidth)   -- 64 posicoes de 32 bits cada
   port map ( 
			 clk      => CLK,
          Endereco => ramAddr,
          Dado_in  => dataInRam,
          Dado_out => dataOutRam,
          we       => weRamMips
        );
	
	ula1 : entity work.ULASomaSub generic map(larguraDados => dataWidth)
	port map (
		entradaA => inputUlaRamAddrA,
		entradaB => inputUlaRamAddrB,
		saida    => outUla,
		seletor  => '1');


end architecture;