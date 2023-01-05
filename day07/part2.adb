with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Part2 is
    type DirectoryNode is record
       Parent : Integer := -1;
       Size : Integer := 0;
    end record;

    package DirectoryVector is new Ada.Containers.Vectors(
        Index_Type   => Natural,
        Element_Type => DirectoryNode
    );

    procedure AddChildSize(
        vec : in out DirectoryVector.Vector;
        parent : Natural;
        val : Integer
    ) is
        procedure Add(dir : in out DirectoryNode) is
        begin
            dir.Size := dir.Size + val;
        end Add;
    begin
        vec.Update_Element(parent, Add'Access);
    end AddChildSize;
        

    file : File_Type;
    line : Unbounded_String;
    Directories : DirectoryVector.vector;
    cDir : DirectoryNode;
    min : Integer := 0;

begin
    Open(file, In_File, "input.txt");
    Skip_Line(file);
    while not End_OF_File(file) loop
        line := To_Unbounded_String(Get_Line(file));

        case Element(line, 3) is
            when 'l' | 'r' => null;
            when 'c' =>
                if min = 0 then
                    Directories.Append(cDir);

                    min := 1;
                    cDir.Size := 0;
                    cDir.Parent := Directories.Last_Index;
                end if;

                if Element(line, 6) = '.' then
                    cDir.Parent := Directories.Element(cDir.Parent).Parent;
                else min := 0; end if;
            when others =>
                cDir.Size := cDir.Size + Integer'Value(
                    Slice(line, 1, Index(line, " ", 2) - 1));
        end case;
    end loop;
    Directories.Append(cDir);
    Close(file);

    for dir of reverse Directories loop
        if dir.Parent /= -1 then
            AddChildSize(Directories, dir.Parent, dir.Size);
        end if;
    end loop;
    cDir.Size := Directories(0).Size - 40000000;
    min := 70000000;
    for dir of Directories loop
        if cDir.Size <= dir.Size and dir.Size < min then
            min := dir.Size;
        end if;
    end loop;
    Put_Line("The smallest valid directory: " & min'Image);
end Part2;
