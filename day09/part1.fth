include ./util.fth

: approx-sqrt ( radicand -- root )
    dup 1 > if \ check if the radicand is 0, 1 or less
        dup 2 / swap >r 1 \ get the lower and upper bounds
        begin 2dup >= while
            2dup + 2 / \ get the middle
            dup dup * \ get the middle^2
            r@ over < if drop 1 - rot drop swap else \ upper bound = middle - 1 
            r@ = if nip nip 1 + 0 swap \ upper bound = 0, lower bound = middle + 1
            else nip 1 + then then \ lower bound = middle + 1
        repeat
        rdrop \ remove the radicand
        nip 1 - \ subtract 1 from the answer
    then ;

: approx-distance ( x1 y1 x2 y2 -- dist ) rot - dup * -rot swap - dup * + approx-sqrt ;

: hash-pair ( x y -- h ) 
    swap 1 lshift dup 0 < if negate 1 - then
    swap 1 lshift dup 0 < if negate 1 - then
    2dup >= if over dup * + + else dup * + then ;

: compare-rope ( instruction direction rope-addr -- )
    4 0 do I pick I cells + @ loop 2over approx-distance \ get distance between rope points
    1 > if rot 2 cells + tuck cell + ! tuck ! + +!  \ copy the head to the tail 
    else 2drop 2drop drop then ;

act-new value locations
: execute-instructions ( rope-addr max fname-addr fname-len -- )
    r/w open-file throw >r \ open file and throw fp onto rstack
    begin pad over r@ read-line throw \ iterate through file
    while
        rot >r pad tuck dup c@ \ get the instruction
        80 > -2 * 1 - \ get the sign of the direction
        -rot 2 + swap 2 - 0 here 2swap >number throw 2drop \ get the amount of instruction
        rot c@ dup 76 = swap 82 = or 1 + cells \ get direction
        r@ 2swap 0 do \ loop instruction number of times
            swap dup 2 cells + @ over 3 cells + @ hash-pair \ hash the tail
            dup locations act-insert swap \ insert value into avl tree
            dup 2over + +! \ move rope by 1
            dup negate 2over compare-rope
        loop 2drop drop r> swap 
    repeat r> close-file throw 2drop
    dup 2 cells + @ swap 3 cells + @ hash-pair
    dup locations act-insert ;

: main 
    4 cells dup allocate throw tuck swap erase \ create rope
    10 s" input.txt" execute-instructions \ run instructions
    locations act-length@ . \ print the length
    locations act-free ;

: return 10 emit bye ;

main
return
