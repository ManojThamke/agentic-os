-- Supabase (Postgres): create table + insert 10 sample trades
CREATE TABLE IF NOT EXISTS trades (
  id INTEGER PRIMARY KEY,
  trade_date DATE NOT NULL,
  symbol TEXT NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('BUY','SELL')),
  qty INTEGER NOT NULL,
  entry_price NUMERIC(10,2) NOT NULL,
  exit_price NUMERIC(10,2),
  stop_loss NUMERIC(10,2),
  pnl NUMERIC(10,2),
  notes TEXT
);

INSERT INTO trades (id, trade_date, symbol, side, qty, entry_price, exit_price, stop_loss, pnl, notes) VALUES
  (1, '2026-10-01', 'RELIANCE', 'BUY', 10, 2850.00, 2895.50, 2820.00, 455.00, 'Breakout above resistance'),
  (2, '2026-10-01', 'TCS', 'SELL', 5, 4120.00, 4085.00, 4150.00, 175.00, 'Weak IT sector'),
  (3, '2026-10-03', 'INFY', 'BUY', 15, 1890.00, 1872.00, 1870.00, -270.00, 'Stop loss hit'),
  (4, '2026-10-03', 'HDFCBANK', 'BUY', 20, 1650.00, 1688.00, 1630.00, 760.00, 'Bank Nifty strength'),
  (5, '2026-10-06', 'SBIN', 'BUY', 25, 820.00, 835.50, 810.00, 387.50, 'Volume spike'),
  (6, '2026-10-06', 'TATAMOTORS', 'SELL', 30, 965.00, 972.00, 980.00, -210.00, 'Reversal failed'),
  (7, '2026-10-07', 'ICICIBANK', 'BUY', 12, 1240.00, 1262.00, 1225.00, 264.00, 'Trend continuation'),
  (8, '2026-10-08', 'ITC', 'BUY', 50, 465.00, 471.20, 460.00, 310.00, 'Support bounce'),
  (9, '2026-10-09', 'WIPRO', 'SELL', 40, 545.00, 538.00, 552.00, 280.00, 'Gap down follow-through'),
  (10, '2026-10-10', 'AXISBANK', 'BUY', 18, 1180.00, 1171.00, 1168.00, -162.00, 'Choppy market')
ON CONFLICT (id) DO NOTHING;

-- Check
SELECT COUNT(*) AS total_trades, SUM(pnl) AS total_pnl FROM trades;
