use std::fs;

const INPUT: &str = "input.txt";

fn main() {
    let mut total = 0;
    let mut elf1: Vec<u8>;
    let mut elf2: Vec<u8>;
    let mut sections: Vec<&str>;

    for line in fs::read_to_string(INPUT).expect("Should have read the file").lines() {
        sections = line.split(",").collect();
        elf1 = parse_integers(sections[0]);
        elf2 = parse_integers(sections[1]);

        if  (elf2[0] >= elf1[0] && elf2[0] <= elf1[1]) ||
            (elf1[0] >= elf2[0] && elf1[0] <= elf2[1]) {
            total += 1;
        }
    }
    println!("The answer is {}", total);
}

fn parse_integers(section: &str) -> Vec<u8> {
    return section.split('-')
          .map(|s| s.parse().unwrap())
          .collect();
}
