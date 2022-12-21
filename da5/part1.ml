open Stdlib

let reverse stack =
    let stack_copy = Stack.copy stack in
    Stack.clear stack;
    Stack.iter (fun x -> Stack.push x stack) stack_copy

let rec move_crates n stack_from stack_to =
    if n <= 0 then ()
    else begin
        Stack.push (Stack.pop stack_from) stack_to;
        move_crates (n-1) stack_from stack_to
    end

let stacks : (char Stack.t) list = List.init 9 (fun x -> Stack.create ());;
let ichannel = open_in "input.txt" in
    try
        (* Load crates into stacks list *)
        let char_dist = ref 0 in
        let current_index = ref 0 in
        for i = 1 to 8 do
            current_index := 0;
            String.iter (fun c ->
                match c with
                | 'A' .. 'Z' -> begin
                    current_index := !current_index + 1 + (!char_dist / 4);
                    Stack.push c (List.nth stacks (!current_index-1));
                    char_dist := 0
                end
                | _ -> char_dist := !char_dist + 1
            ) (input_line ichannel)
        done;
        List.iter reverse stacks;

        (* Read 2 useless lines *)
        ignore (input_line ichannel);
        ignore (input_line ichannel);

        (* Run the move commands *)
        while true do
            Scanf.sscanf (input_line ichannel) "move %d from %d to %d" 
            (fun x y z -> begin
                move_crates x (List.nth stacks (y-1)) (List.nth stacks (z-1))
            end)
        done
    with End_of_file ->
        close_in ichannel;
        
        (* Print results *)
        List.iter (fun s -> print_char (Stack.pop s)) stacks;
        print_endline ""
