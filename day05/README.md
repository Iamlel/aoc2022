# Day 5: Supply Stacks

The expedition can depart as soon as the final supplies have been unloaded from the ships. Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates, the crates need to be rearranged.

The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the top of each stack.

The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

```
[D]    
[N] [C]  
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
```
In this example, there are three stacks of crates. Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains three crates; from bottom to top, they are crates M, C, and D. Finally, stack 3 contains a single crate, P.

Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1, resulting in this configuration:
```
[D]  
[N] [C]  
[Z] [M] [P]
 1   2   3 
```
In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

```
       [Z]
       [N]
   [C] [D]
   [M] [P]
1   2   3
```
Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

```
       [Z]
       [N]
   [M] [D]
   [C] [P]
1   2   3
```
Finally, one crate is moved from stack 1 to stack 2:

```
        [Z]
        [N]
        [D]
[C] [M] [P]
 1   2   3
```
The Elves just need to know which crate will end up on top of each stack; in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine these together and give the Elves the message CMZ.

After the rearrangement procedure completes, what crate ends up on top of each stack?

### Solution

Day 5 was a bit more challenging, especially because of the input. To start, you would probably want to use 9 [Stacks](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)). To load them up with the data, you could begin by taking note of the fact that if a stack is missing, there is a space of x amount of characters between the current stack and the next stack. If you keep track of the space, you can then add this to the current index, to get the next stack: $1 + \bf{div}(x, 4)$ where x is the number of characters between each letter (including the brackets). After you push the characters, and get through the 8 lines of crates, you can skip 2 useless lines and get to the easy part. All you need to do here is get the 3 integers, the first integer corresponds to the number of times you need to push and pop from the two different stacks. You can simply use a **for** loop, and pop from the second integer to the third one. And once done, just iterate through the list, and print the first element on the stack!

## Part 2

As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.

Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder, and the ability to pick up and move multiple crates at once.

Again considering the example above, the crates begin in the same configuration:

```
[D]    
[N] [C]  
[Z] [M] [P]
 1   2   3 
```
Moving a single crate from stack 2 to stack 1 behaves the same as before:
```
[D]  
[N] [C]  
[Z] [M] [P]
 1   2   3 
```
However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order, resulting in this new configuration:

```
        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3 
```
Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:

```
        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3 
```
Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

```
        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3 
```
In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.

Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand to be ready to unload the final supplies. After the rearrangement procedure completes, what crate ends up on top of each stack?

### Solution

A bit annoying that we can't use stacks anymore.. or can we? All we have to do for this part is use an extra temporary stack that we push our popped element to, before popping them off once again, and pushing them to our destination stack. This was my code for this:

```ocaml
let move_crates_with_order n stack_from stack_to =
    let temp_crates = Stack.create () in
    move_crates n stack_from temp_crates;
    move_crates n temp_crates stack_to
```
