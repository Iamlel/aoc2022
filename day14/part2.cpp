#include <iostream>
#include <fstream>
#include <string>
#include <set>
#include <stack>
#include <cmath>
using namespace std;

#define isqrt(x) floor(sqrt(x))

int Pair(int x, int y) {
    if (x >= y) { return (x * x + x + y); }
    else        { return (y * y + x    ); }
}

int UnPairY(int z) {
    int sqrtz = isqrt(z);
    int sqz = sqrtz * sqrtz;
    return (z - sqz < sqrtz) ? sqrtz : z - sqz - sqrtz;
}

// return highest y
int set_fill_range(int coords[], set<int> &obstacles, int cy) {
    if (coords[0] == coords[2]) {
        coords[0] = max(coords[1], coords[3]);
        for (int x = min(coords[1], coords[3]); x <= coords[0]; x++) {
            obstacles.insert(Pair(coords[2], x));
        }
    } else {
        coords[1] = max(coords[0], coords[2]);
        for (int x = min(coords[0], coords[2]); x <= coords[1]; x++) {
            obstacles.insert(Pair(x, coords[3]));
        }
        if (cy < coords[3]) { return coords[3]; }
    }
    return cy;
}

int main() {
    set<int> obstacles;
    int floor_y = 0;

    string line;
    ifstream fp ("input.txt");
    while (getline(fp, line)) {
        int coordsTracker = 0;
        int coords[4] = {0};
        for (int i = 0; i < line.length(); i++) {
            switch (line[i]) {
                case ' ':
                case '-':
                    break;

                case '>':
                    if (coordsTracker == 3) {
                        floor_y = set_fill_range(coords, obstacles, floor_y);

                        coords[0] = coords[2];
                        coords[1] = coords[3];
                        coords[2] = 0;
                        coords[3] = 0;

                        coordsTracker = 1;
                    }
                case ',':
                    coordsTracker++;
                    break;

                default:
                    coords[coordsTracker] *= 10;
                    coords[coordsTracker] += line[i] - '0';
            }  
        }
        floor_y = set_fill_range(coords, obstacles, floor_y);
    }

    floor_y += 2;
    stack<int> sand_path;
    int units = 0;

    sand_path.push(250500);
    while (sand_path.size() != 0) {
        int sand = sand_path.top() + 1;
        if (UnPairY(sand) != floor_y) {
            if (obstacles.find(sand) == obstacles.end()) { 
                sand_path.push(sand);
                continue;
            } else if (obstacles.find(sand - isqrt(4 * sand + 1) + 1) == obstacles.end()) {
                sand_path.push(sand - isqrt(4 * sand + 1) + 1);
                continue;

            } else if (obstacles.find(sand + isqrt(4 * sand + 1) + 1) == obstacles.end()) {
                sand_path.push(sand + isqrt(4 * sand + 1) + 1);
                continue;
            }
        }
        obstacles.insert(sand_path.top());
        sand_path.pop();
        units++;
    }

    cout << units << endl;
    return 0;
}
