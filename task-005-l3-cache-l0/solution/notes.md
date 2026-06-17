# FSM Backdoor - Solution Notes

## Vulnerability
`fsm_secure.v` contains a hidden BYPASS state (3'h4) in the security FSM:

```verilog
else if (cmd == 3'h7) state <= BYPASS;  // undocumented transition
...
BYPASS: if (cmd == 3'h3) backdoor_active <= 1;
```

## Attack Method
1. Read `/opt/assets/fsm_secure.v` and trace all state transitions
2. Find the undocumented BYPASS state entered via cmd=7
3. POST `{"cmd1": 7, "cmd2": 3}` to `http://target:8101/sequence`
4. Response includes `"backdoor_active": true` and `"flag"`
