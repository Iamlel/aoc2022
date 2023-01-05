use List::MoreUtils qw(first_index);

open(my $fh, '<', "input.txt") or die $!;
my @line = split("", <$fh>);
close($fh);

my $offset = -1;
my $position = 1;
my @queue = ();
my $char = $line[0];

while ($offset != -1 or scalar @queue != 3) {
    push(@queue, $char);
    for (0..$offset) { shift(@queue); }
    $char = $line[$position];
    $position++;
    $offset = first_index { $_ eq $char } @queue;
}
print "$position\n";
