# Task 001: RTL Timing Side-Channel (Level 3)

**Algorithm:** Bit-by-bit recovery using timing analysis

For each of 256 bits:
1. Try bit=0, measure timing
2. Try bit=1, measure timing
3. Higher timing indicates correct bit

**Implementation:**
- Build guesses incrementally
- Send ~512 HTTP requests (2 per bit)
- Reconstruct 256-bit secret
