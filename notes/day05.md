# Day 5: IF and CASE Constructs
---

## IF Statement
The **if-else** statement is one of the most commonly used conditional constructs in Verilog.
### General Syntax
```verilog
always @(*) begin
    if(condition1)
        statement1;
    else if(condition2)
        statement2;
    else
        statement3;
end
```
---
## Hardware Representation
An **if-else-if** chain is synthesized as **priority logic**.
Example:
```verilog
always @(*) begin
    if(c1)
        y = a;
    else if(c2)
        y = b;
    else if(c3)
        y = c;
    else
        y = d;
end
```
Hardware:
```
c1 (Highest Priority)
        │
        ▼
      MUX
        │
c2 ───►MUX
        │
c3 ───►MUX
        │
else ─►MUX
        │
        ▼
        y
```
The synthesizer checks conditions **from top to bottom**.
The first TRUE condition gets executed.
---

## Priority Logic
Suppose,
```
c1 = 1
c2 = 1
c3 = 1
```
Output becomes
```
y = a
```
because **Condition 1 has highest priority.**
Priority Order
```
Condition1
      ↓
Condition2
      ↓
Condition3
      ↓
Else
```
---
## Danger with IF Statement
Consider the following code.
```verilog
always @(*) begin
    if(c1)
        y = a;
    else if(c2)
        y = b;
end
```
There is **no else statement.**
Suppose,
```
c1 = 0
c2 = 0
```
No assignment is made to **y**.
The synthesizer therefore assumes
```
y should retain its previous value.
```
To remember the previous value, hardware requires a **Latch**.
Hence,
```
Incomplete IF
        ↓
Inferred Latch
```
This is considered poor RTL coding.
---

### Correct Coding Style
Always provide an **else**.
```verilog
always @(*) begin
    if(c1)
        y = a;
    else if(c2)
        y = b;
    else
        y = 1'b0;
end
```
Now every condition assigns a value.
No latch is inferred.
---

## Exception – Sequential Logic
Example
```verilog
always @(posedge clk or posedge reset)
begin
    if(reset)
        count <= 3'b000;
    else if(enable)
        count <= count + 1;
end
```
Although there is no **else**, this is correct.
Reason:
When enable is LOW,
```
Count should hold its previous value.
```
A flip-flop naturally stores its previous state.
No latch is inferred.
This is the correct coding style for sequential circuits.
---

## CASE Statement
CASE is used when a signal can take multiple values.
General Syntax
```verilog
always @(*) begin
case(sel)
2'b00 : y = a;
2'b01 : y = b;
2'b10 : y = c;
2'b11 : y = d;
endcase
end
```
---
## Hardware Representation
CASE is synthesized as a **Multiplexer**.
```
          sel
           │
           ▼

      +-----------+
a ---->|           |
b ---->|   4:1     |----> y
c ---->|   MUX     |
d ---->|           |
      +-----------+
```
Unlike IF,
CASE does **not** create priority logic.
It simply selects one input.
---

## IF vs CASE
| IF Statement | CASE Statement |
|--------------|----------------|
| Implements priority logic | Implements multiplexers |
| Conditions checked sequentially | Values checked directly |
| First TRUE condition executes | Matching case executes |
| Used for priority encoders | Used for MUX, Decoder, FSM |
---

## Incomplete CASE
Example
```verilog
always @(*) begin
case(sel)
2'b00 : y = a;
2'b01 : y = b;
endcase
end
```
Missing
```
2'b10
2'b11
```
Suppose,
```
sel = 2'b10
```
No assignment occurs.
Hence
```
Previous value is retained.
```
Synthesizer inserts a **Latch**.
---

### Correct Coding
Always include **default**.
```verilog
always @(*) begin
case(sel)
2'b00 : y = a;
2'b01 : y = b;
default : y = 0;
endcase
end
```
Now every possible input has an assignment.
No latch is inferred.
---

## Partial Assignment in CASE
Example
```verilog
always @(*) begin
case(sel)
2'b00 :
begin
    x = a;
    y = b;
end
2'b01 :
begin
    x = c;
end
default :
begin
    x = d;
    y = e;
end
endcase
end
```
Problem
For
```
sel = 2'b01
```
Only
```
x
```
is assigned.
```
y
```
retains its previous value.
Hence,
```
Latch is inferred.
```
---

### Correct Coding
Assign every output in every branch.
```verilog
always @(*) begin
case(sel)
2'b00 :
begin
    x = a;
    y = b;
end
2'b01 :
begin
    x = c;
    y = d;
end
default :
begin
    x = e;
    y = f;
end
endcase
end
```
---

## Coding Guidelines
### For Combinational Logic
```verilog
always @(*)
```

✔ Use blocking assignment
```verilog
=
```
✔ Assign every output.
✔ Always include
- else
- default
---
### For Sequential Logic
Use
```verilog
always @(posedge clk)
```
Use
```verilog
<=
```
(non-blocking assignment)
It is acceptable to omit the **else** because flip-flops naturally store previous values.
---

## Best Practices
- Use **IF** when priority is required.
- Use **CASE** for multiplexers and finite state machines.
- Always assign every output in every branch.
- Never leave IF or CASE incomplete.
- Always include **default** in CASE statements.
- Avoid inferred latches unless intentionally required.
- Use blocking (`=`) for combinational logic.
- Use non-blocking (`<=`) for sequential logic.
---