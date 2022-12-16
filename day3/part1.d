import std.stdio;
import std.conv;
import std.algorithm;
import std.array;
import std.string;

static int priority(int c) { return c - ((c > 96) ? 96 : 38); }

void main() { 
    File file = File("input.txt", "r"); 

    int total = 0;
    int[] input;
    int median;

    while (!file.eof()) {
        input = file.readln.chomp.map!(c => to!int(c).priority).array;
        
        median = to!int(input.length * 0.5);

        for (int x = 0; x < median; x++) {
            if (input[median..$].canFind(input[x])) {
                median -= input[0..median].count;
                total += input[x];

                for (int i = 0; i < input.length; i++) {
                    if (input[i] == 5) {
                        input.remove(i);
                        i--;
                    }
                }
            }
        }
    }

    writeln(total);
    file.close(); 
}
