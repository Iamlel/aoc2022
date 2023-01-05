program AOCDay10Part1;
uses sysutils;

var
    fp : text;
    line : string;
    cycles : byte = 0;
    regx : shortint = 0;

procedure Cycle();
begin
    if (cycles = 40) then begin
        writeln();
        cycles := 0;
    end;
    if (cycles >= regx) and (cycles - 2 <= regx) then write('▇')
    else write(' ');
    cycles += 1;
end;

begin
    assign(fp, 'input.txt');
    reset(fp);
    while not EOF(fp) do begin
        readln(fp, line);
        Cycle();

        if (line[1] = 'a') then begin
            Cycle();
            regx += strtoint(copy(line, 6, length(line)));
        end;
    end;
    writeln();
    close(fp);
end.
