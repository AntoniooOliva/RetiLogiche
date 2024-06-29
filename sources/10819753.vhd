--------------------------------------------------------------------------------------------------
-- Company:         Politecnico di Milano
-- Engineer:        Oliva Antonio
-- Personal Code:   10819753
--
-- Create Date: 29.02.2024 09:41:09
--------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_add : in std_logic_vector(15 downto 0);
        i_k : in std_logic_vector(9 downto 0);

        o_done : out std_logic;
        
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic);
end project_reti_logiche;

architecture project_arch of project_reti_logiche is
    type stato is (Inizio, Lettura, Scrittura, SecondaScrittura, Fine);
    signal current : stato := Inizio;
    
begin
    fsm : process (i_clk, i_rst)
    variable W : std_logic_vector (7 downto 0);
    variable LastW : std_logic_vector (7 downto 0);
    variable C : std_logic_vector (7 downto 0);
    variable K : std_logic_vector (9 downto 0);
    variable ADD : std_logic_vector(15 downto 0);
    variable parola_letta : std_logic := '0';
    
    begin
        if i_rst = '1' then
            o_done <= '0';
            o_mem_en <= '0';
            o_mem_we <= '0';
            
            o_mem_addr <= (others => '0');
            o_mem_data <= (others => '0');
            
            ADD := (others => '0');
            K := (others => '0');
            W := (others => '0');
            LastW := (others => '0');
            C := (others => '0');
            current <= Inizio;
        
        elsif rising_edge (i_clk) then
            case current is
                when Inizio =>
                    if i_start = '1' then
                        ADD := i_add;
                        K := i_k;
                        o_mem_en <= '1';
                    
                        current <= Lettura;
                    
                    else current <= Inizio;
                    end if;
                
                when Lettura =>
                    if parola_letta = '0' then
                        o_mem_we <= '0';
                        if K /= (9 downto 0 => '0') then
                            o_mem_addr <= ADD;
                            parola_letta := '1';
                            current <= Lettura;
                        
                        else
                            o_mem_en <='0';
                            o_done <= '1';
                            current <= Fine;
                        end if;
                    else current <= Scrittura;
                    end if;
                
                when Scrittura =>
                    W := i_mem_data;
                    parola_letta := '0';
                    
                    if W = (7 downto 0 => '0') then
                        if K = i_k then
                            LastW := (others => '0');
                            C := (others => '0');
                            ADD := std_logic_vector(unsigned(ADD) + 1);
                            o_mem_addr <= ADD;
                            o_mem_data <= C;
                            o_mem_we <= '1';
                            
                            current <= Lettura;
                            ADD := std_logic_vector(unsigned(ADD) + 1);
                            K := std_logic_vector(unsigned(K) - 1);
                            
                        else
                            o_mem_data <= LastW;
                            o_mem_we <= '1';
                            
                            if C /= (7 downto 0 => '0') then
                                C := std_logic_vector(unsigned(C) - 1);
                            end if;
                            current <= SecondaScrittura;
                            
                        end if;
                    else
                        LastW := W;
                        C := "00011111";
                        ADD := std_logic_vector(unsigned(ADD) + 1);
                        o_mem_addr <= ADD;
                        o_mem_data <= C;
                        o_mem_we <= '1';
                        
                        current <= Lettura;
                        ADD := std_logic_vector(unsigned(ADD) + 1);
                        K := std_logic_vector(unsigned(K) - 1);
                    end if;
                    
                when SecondaScrittura =>
                    o_mem_addr <= std_logic_vector(unsigned(ADD) + 1);
                    o_mem_data <= C;
                    o_mem_we <= '1';
                    
                    current <= Lettura;
                    ADD := std_logic_vector(unsigned(ADD) + 2);
                    K := std_logic_vector(unsigned(K) - 1);
                
                when Fine =>
                    if i_start = '0' then
                        o_done <= '0';
                        current <= Inizio;
                    end if;
            
                when others =>
                    current <= Inizio;
            
            end case;
        end if;
    end process;

end project_arch;
