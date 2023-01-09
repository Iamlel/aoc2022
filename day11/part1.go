package main

import (
    "strings"
    "strconv"
    "bufio"
    "queue"
    "sort"
    "fmt"
    "os"
)

type Monkey struct {
    Op byte
    items queue.Queue
    OpNum, TestNum, TrueMonkey, FalseMonkey int
}

func main() {
    monkeys := []Monkey{}
    cMonkey := new(Monkey)

    fp, err := os.Open("./input.txt")
    if (err != nil) { panic(err) }
    defer fp.Close()

    scanner := bufio.NewScanner(fp)
    for scanner.Scan() {
        line := scanner.Text()

        if (len(line) == 0) {
            monkeys = append(monkeys, *cMonkey)

        } else {
            switch (line[8]) {
                case 'n':
                    for _, item := range strings.Split(line[18:], ", ") {
                        item, _ := strconv.Atoi(item)
                        cMonkey.items.Add(item)
                    }

                case 'i':
                    cMonkey.OpNum, err = strconv.Atoi(line[25:])
                    if (err != nil) {
                        switch (line[23]) {
                            case 42: // *
                                cMonkey.Op = 94 // ^
                            case 43: // +
                                cMonkey.Op = 42 // *
                        }
                        cMonkey.OpNum = 2
                    } else { cMonkey.Op = line[23] }

                case 'd':
                    cMonkey.TestNum, _ = strconv.Atoi(line[21:])

                case 'r':
                    cMonkey.TrueMonkey = int(line[29] - 48)

                case 'a':
                    cMonkey.FalseMonkey = int(line[30] - 48)

                default:
                    cMonkey.items = *queue.New()
            }
        }
    }
    monkeys = append(monkeys, *cMonkey)

    monkeyActivity := make([]int, len(monkeys))
    for x := 0; x < 20; x++ {
        for i := range monkeys {
            for y := monkeys[i].items.Length(); y > 0; y-- {
                monkeyActivity[i]++

                item, _ := monkeys[i].items.Peek().(int)
                monkeys[i].items.Remove()
                switch (monkeys[i].Op) {
                    case 94: // ^
                        for z := 1; z < monkeys[i].OpNum; z++ { item *= item }

                    case 42: // *
                        item *= monkeys[i].OpNum

                    case 43: // +
                        item += monkeys[i].OpNum
                }

                item /= 3
                if (item % monkeys[i].TestNum == 0) {
                    monkeys[monkeys[i].TrueMonkey].items.Add(item)
                } else {
                    monkeys[monkeys[i].FalseMonkey].items.Add(item)
                }
            }
        }
    }
    sort.Sort(sort.Reverse(sort.IntSlice(monkeyActivity)))
    fmt.Println(monkeyActivity[0] * monkeyActivity[1])
}
