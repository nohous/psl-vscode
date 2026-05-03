-- example.vhd: regular VHDL with embedded PSL directives.
-- Lines starting with '-- psl' should be re-tokenized; ordinary
-- '--' lines should remain plain comment-colored.

library ieee;
use ieee.std_logic_1164.all;

entity counter is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    en    : in  std_logic;
    count : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of counter is
  signal cnt : unsigned(3 downto 0) := (others => '0');
begin

  -- Plain VHDL comment: should stay vanilla comment-colored.
  -- This one too.

  -- psl default clock is rising_edge(clk);

  -- psl property no_overflow is always (cnt < 16);
  -- psl assert no_overflow report "counter overflowed";

  -- psl property handshake is always (en -> next_event_a!(rst)(cnt = 0 until! en));
  -- psl assume handshake;

  -- psl sequence burst is {en; cnt[*4]; not en};
  -- psl cover burst;

  -- psl property no_deadlock is always (en -> eventually! (cnt = 15)) abort rst;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt <= (others => '0');
      elsif en = '1' then
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  count <= std_logic_vector(cnt);

end architecture;
