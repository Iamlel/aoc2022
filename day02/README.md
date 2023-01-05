# Day 2: Rock Paper Scissors

The Elves begin to set up camp on the beach. To decide whose tent gets to be closest to the snack storage, a giant Rock Paper Scissors tournament is already in progress.

Rock Paper Scissors is a game between two players. Each game contains many rounds; in each round, the players each simultaneously choose one of Rock, Paper, or Scissors using a hand shape. Then, a winner for that round is selected: Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock. If both players choose the same shape, the round instead ends in a draw.

Appreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

Since you can't be sure if the Elf is trying to help you or trick you, you should calculate the score you would get if you were to follow the strategy guide.

For example, suppose you were given the following strategy guide:

```
A Y
B X
C Z
```

This strategy guide predicts and recommends the following:

In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.
In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

What would your total score be if everything goes exactly according to your strategy guide?

### Solution

This puzzle is about [rock, paper, scissors](https://en.wikipedia.org/wiki/Rock_paper_scissors). One thing that you can notice immediately is that the opponent's response is either A, B, or C; while your response is either Y, X, or Z. Instead of using enum values for this, we can instead convert to ASCII, and do the following math to get result of each round: $\bmod(Y - X - 19, 3) * 3 + Y - 87$ where X is the opponent's choice in ascii, and Y is your choice in ascii.

First, we have: $X - Y - 19$ where we take the difference between the two choices and subtract 19 to get a value between 2 and 6. We do this to get a value that will determine whether you won, lost, or tied when we take the $\bmod$ of it. We use $\bmod$ to clamp the result to 3 values instead of 5, because there are only 3 possibilities: winning, losing, drawing (and we originally have 5 because of the way rock, paper scissors works: rock beats scissors, scissors beats paper, but paper beats rock forming a loop). Next, we multiply by 3 to get either 0, 3, or 6 instead of 0, 1, or 2. Finally, we add the value of your response to the total, as the prompt tells us to. Since X, Y, and Z have the values 88, 89, and 90, instead of 1, 2, 3; we need to subtract 87.

## Part 2

The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: `X` means you need to lose, `Y` means you need to end the round in a draw, and `Z` means you need to win. Good luck!"

The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

- In the first round, your opponent will choose Rock (`A`), and you need the round to end in a draw (`Y`), so you also choose Rock. This gives you a score of 1 + 3 = *4*.
- In the second round, your opponent will choose Paper (`B`), and you choose Rock so you lose (`X`) with a score of 1 + 0 = *1*.
- In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = *7*.

Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of `*12*`.

Following the Elf's instructions for the second column, *what would your total score be if everything goes exactly according to your strategy guide?*

### Solution

The solution to this challenge isn't much harder. Before, the unknown was the outcome of the game, but this time, its our choice. Using some algebra, it shouldn't be difficult to reverse the equation in order to account for this. This gives us this equation: $\bmod(X + Z - 1, 3) + 3Z - 263$ where X is the opponent's choice, and Z is the outcome of the game. Keep in mind that we also need to add the amount of points the outcome of the game gives us as before (0, 3, 6).

First lets start with the right side of the equation. This equation gives us either 1, 4, or 7 depending on the outcome of the game. This is simple to do because the outcome of the game was a given to us, as stated before. All we need to do is subtract 263 from it to account for our ascii values being either 88, 89, and 90 -- instead of 0, 1, and 2 -- and then we multiply by 3. However, this doesn't give us the expected 0, 3, or 6, which is done in order to compensate for the $\bmod$ giving us 0, 1, or 2 -- not the 1, 2, or 3 points that we want for our choice. Now the other side of the equation is responsible for giving us the points we would get for choosing the correct response (rock, paper, or scissors). There isn't much too explain; we don't need to subtract anything more than 1 because $\bmod$ takes care of that for us: $\bmod(1, 3)$ and $\bmod(4, 3)$ give the same result, so why would we subtract 3. The only reason we subtract 1 is to shift the answers a tiny bit (instead of getting 2 for rock, we get 0).
