program AOCDay10Part1;
uses sysutils;

var
    fp : text;
    line : string;
    cycles : byte = 0;
    regx : integer = 1;
    total : integer = 0;

procedure Cycle();
begin
    cycles += 1;
    if (cycles mod 40 = 20) then
        total += cycles * regx
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
    writeln(total);
    close(fp);
end.
