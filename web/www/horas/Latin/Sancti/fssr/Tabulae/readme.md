The calendar needs to have an entry in
`web/www/horas/Latin/Tabulae/data.txt`

```
Redemptorist-1960,fssr,fssr,fssr,Rubrics 1960
```

The primary "Saints" calendar is in:
`web/www/horas/Latin/Tabulae/Kalendaria/fssr.txt`

There is also a calendar for feasts such as the "Eucharistic Heart of Jesus" 
that falls on the Thursday of the third week after Pentecost, found in:
`web/www/horas/Latin/Tabulae/Tempora/fssr.txt`

The final component of the calendar is found in:
`web/www/horas/Latin/Tabulae/Transfer`

There are 7 files, `a.txt` through `g.txt`. These correspond to the "Letters
denoting Sundays". The calculation is found in `Directorium.pm`:
```
my $letter = ($easter - 319 + ($easter[1]==4?1:0))%7;
my @letters = ('a','b','c','d','e','f','g');
```
It can also be calculated by taking the day number of 1 January (1=Sun, 2=Mon, etc)
Then use the following table to get the letter corresponding to that number:
```
A, g, f, e, d, c, b
```
For leap years, there are two letters, one for before 24 Feb, and another for
after. The first letter is calculated using the standard method. The second will
be the letter preceding the first. (e.g. a "c" leap year would be "b" after 24 Feb,
"d" would be "c", etc. "A" would be "g".)

The fssr modifications for the "sunday" files are stored here to help prevent
merge conflicts with the main git repository. To re-apply them to the files,
the following (linux/bash) script can be used, from the root of the repository:
```
latin=web/www/horas/Latin
dest=$latin/Tabulae/Transfer
src=$latin/Sancti/fssr/Tabulae
force=1 # set this to 1 to "force" changes, remove fssr lines from file
for d in a b c d e f g; do
  c=1
  f=$d.txt
  fs=$src/$f
  fd=$dest/$f
  echo $fd
  grep -qE ";;fssr$" $fd && {
    [[ $force = 1 ]] && {
      sed -i -Ee '/^[ \t]*$/d' -e '/;;fssr$/d' $fd
    } || {
      echo "$d.txt - no mods needed"
      c=0
    }
  }
  [[ $c = 1 ]] && {
    echo "$fd - adding fssr lines"
    cat $fs >> $fd
  }
done

```