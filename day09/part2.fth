include ./util.fth

: hash-pair ( x y -- h ) 
    swap 1 lshift dup 0 < if negate 1 - then
    swap 1 lshift dup 0 < if negate 1 - then
    2dup >= if over dup * + + else dup * + then ;

: normalize dup abs 2 = if 2 / then ;

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
            dup 2over + +! \ move rope by 1
            over 9 0 do
                2 cells + >r \ get next rope knot
                r@ 2 cells - @ r@ @ - \ head x - tail x
                r@ cell - @ r@ cell + @ - \ head y - tail y
                
                2dup abs 1 > swap abs 1 > or if \ check the distance
                    normalize swap normalize \ divide by 2 if its -2 or 2
                    r@ +! r@ cell + +! \ increment by displacement vector
                else 2drop then r>
            loop drop
            swap dup 18 cells + @ over 19 cells + @ hash-pair \ hash the tail
            dup locations act-insert swap \ insert value into avl tree
        loop 2drop drop r> swap 
    repeat r> close-file throw 2drop drop ;

: main 
    20 cells dup allocate throw tuck swap erase \ create rope
    10 s" input.txt" execute-instructions \ run instructions
    locations act-length@ . \ print the length
    ;

: return 10 emit bye ;

main
return
