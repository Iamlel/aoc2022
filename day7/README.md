# Day 7: No Space Left On Device

You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

```
$ system-update --please --pretty-please-with-sugar-on-top
Error: No space left on device
```

Perhaps you can delete some files to make space for the update?

You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

```
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
```

The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called `/`. You can navigate around the filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

Within the terminal output, lines that begin with `$` are *commands you executed*, very much like some modern computers:

- `cd` means *change directory*. This changes which directory is the current directory, but the specific result depends on the argument:
  - `cd x` moves *in* one level: it looks in the current directory for the directory named `x` and makes it the current directory.
  - `cd ..` moves *out* one level: it finds the directory that contains the current directory, then makes that directory the current directory.
  - `cd /` switches the current directory to the outermost directory, `/`.
- `ls` means *list*. It prints out all of the files and directories immediately contained by the current directory:
  - `123 abc` means that the current directory contains a file named `abc` with size `123`.
  - `dir xyz` means that the current directory contains a directory named `xyz`.

Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

```
- / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)
```

Here, there are four directories: `/` (the outermost directory), `a` and `d` (which are in `/`), and `e` (which is in `a`). These directories also contain files of various sizes.

Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the *total size* of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

The total sizes of the directories above can be found as follows:

- The total size of directory `e` is *584* because it contains a single file `i` of size 584 and no other directories.
- The directory `a` has total size *94853* because it contains files `f` (size 29116), `g` (size 2557), and `h.lst` (size 62596), plus file `i` indirectly (`a` contains `e` which contains `i`).
- Directory `d` has total size *24933642*.
- As the outermost directory, `/` contains every file. Its total size is *48381165*, the sum of the size of every file.

To begin, find all of the directories with a total size of *at most 100000*, then calculate the sum of their total sizes. In the example above, these directories are `a` and `e`; the sum of their total sizes is `*95437*` (94853 + 584). (As in this example, this process can count files more than once!)

Find all of the directories with a total size of at most 100000. *What is the sum of the total sizes of those directories?*

### Solution

Day 7 seems to be where the difficulty ramps up, and indeed, it was very time consuming to do in Ada. The data structure of choice is a [Parent pointer tree](https://en.wikipedia.org/wiki/Parent_pointer_tree). To implement this, we need to have a DirectoryNode struct or record, that will store a Parent parameter as an integer, and a Size parameter as another integer. The parent should have a default value of -1 or null, and the size should have a default value of 0. To hold these nodes, we need a list or vector.

Step 1, we will skip the first line of the file, because we will be saving the previous directory in the current directory, reading reading the first line tampers with that. For every line, we will want to check the third character for either a *c*, or not an *l* or *r*. Why do we do this? If the third character is a *c*, then that means change directory, so we have to save our node. If the character is not and *l* or an *r* then that means it is a file that we need to add to the size. The reason we don't do anything for the other two characters is because they are useless. Then, if we have a file, we just parse everything from the first character to the space as a number and add that. If we have a *c* however, its a bit more complex. First, we want to check if our total is 0, and if it is, then we do append a new directory, set the total to 1 (we are using the total here for a boolean), reset size, and set the parent to the last index. The reason for this is because we want to make sure that we aren't appending empty directories when we have rows of consecutive "cd .." And since we just saved a directory, the last index contains the directory that we just saved. Second, we want to check if the sixth character is a period, to see if we are dealing with a "cd .." If it is, we want to get the parent of the current parent which we can do by just using the directory list/vector. Third, if it is not, we want to set total to 0 to indicate this.

Step 2, is fixing up our directories. We want to begin by iterating through the list backwards, adding the size of the current dir to our total if it meets the requirement (being less than 100000), and adding the size of our current dir to its parent. No need to worry about the parent, it will get iterated upon later, and its parent will inadvertently receive the size of our current dir. That's it! Just print the total and you are done.

## Part 2

Now, you're ready to choose a directory to delete.

The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.

In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.

To achieve this, you have the following options:

Delete directory e, which would increase unused space by 584.
Delete directory a, which would increase unused space by 94853.
Delete directory d, which would increase unused space by 24933642.
Delete directory /, which would increase unused space by 48381165.
Directories e and a are both too small; deleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.

Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?

### Solution

Part 2 sadly adds another iteration to our solution. For part 2, we want to preserve the file reading and the loop that fixes our dirs (only remove the if check for the total). After that, we want to calculate how much space our system needs, and set min (which used to be total) to 70000000 just to be safe. Then, we want to iterate through our directories once again, and check if the size of each directory is between the space needed and min, and set min to that directory. Boom! You are done once again, just print min!
