import std.stdio;
import std.conv;
import std.algorithm;
import std.range;

static int priority(int c) { return c - ((c > 96) ? 96 : 38); }

void main() { 
    File file = File("input.txt", "r"); 

    char[] matches, temp;
    int total = 0;

    while (!file.eof()) {
        matches = file.readln.dup;

        foreach (char[] line; file.byLine.take(2)) {
            temp = [];
            foreach (char c; matches) {
                if (line.canFind(c)) {
                    temp ~= c;
                }
            }
            matches = temp;
        }
        total += to!int(matches[0]).priority;
    }

    writeln(total);
    file.close(); 
}
