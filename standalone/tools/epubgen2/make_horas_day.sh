# get repo root
# if run outside of repo, find 
REPODIR=$(git rev-parse --show-toplevel \
  || grep -lr "indyblue/divinum-officium" --include='config' \
  | xargs dirname | xargs dirname | xargs realpath)
echo $REPODIR
CDUR=$REPODIR/standalone/tools/epubgen2
HORA_INDEX_LAST=7
EOFFICCIUMCMD=$CDUR/EofficiumXhtml.pl #the command to launch the genarator
RUBRICS_CODE=1960
RUBRICS=Rubrics%201960
BLANG=Latin
MISSA='' #=1 to include Mass propers
PRIEST='' #has to be empty or '&priest=yes'
VOTIVE='' #='C12' for Parvum B.M.V.
NOFANCYCHARS=1 #0 or 1; when 1, "fancy" characters such as  ℟ ℣ +︎ ✠ ✙︎ are replaced with R. V. + + +
WDIR=$REPODIR/../html-out

HH=
RUBRICS=Redemptorist-1960

HORAS_NAMES=(Matutinum Laudes Prima Tertia Sexta Nona Vespera Completorium Missa)
HORAS_FILENAMES=(1-Matutinum 2-Laudes 3-Prima 4-Tertia 5-Sexta 6-Nona 7-Vespera 8-Completorium)
DATE_SCRIPT=$MDY #$MONTH-$DAY-$YEAR

function make_file(){
  MDY=$1
  Y=`echo $MDY | sed -E 's/^.*-(.+)$/\1/'`
  mkdir -p "$WDIR/$Y/"
  H=$2
  FILENAME=$Y/$MDY-${HORAS_FILENAMES[${H}]}.html
  json="{
    date1: '$MDY',
    command: 'pray${HORAS_NAMES[${H}]}',
    version: '$RUBRICS',
    testmode: 'regular',
    lang2: '$BLANG',
    votive: '$VOTIVE$PRIEST',
    linkmissa: '$MISSA',
    nofancychars: '$NOFANCYCHARS',
    debug: '$debug',
  }"
  arg=`echo "$json" | nwk.sh -e '
    x=jpp(txt);
    x=Object.entries(x);
    x=x.map(a=> a.join("="));
    x=x.join("&");
    log(x);
  '`
  [[ "$*" =~ 'args' ]] && echo "$arg"
  [[ "$*" =~ 'noredir' ]] && {
    $EOFFICCIUMCMD "$arg";
    return
  }
  echo $FILENAME
  [[ 1 = 1 ]] && {
    $EOFFICCIUMCMD "$arg" > $WDIR/$FILENAME
  } || {
    echo DEBUGGING!
    perl -d $EOFFICCIUMCMD "$arg"
    exit
  }
}

y=2024
dates="03-15 06-13 06-27 07-20 07-21 08-01 08-02"
debug=$1

function asdf(){
  echo ${1:-none};
}
[[ "$debug" = 'cal' ]] && {
  NOFANCYCHARS=0
  noredir=1
  ymd=${2:-$y-01-01}
  seq=`seq 0 ${3:-365}`
  for i in $seq; do
    dd=`date +%m-%d-%Y -d "$ymd +$i days"`
    dd2=`date +"%m-%d-%Y %a" -d "$ymd +$i days"`
    echo "$dd2 ($i)"
    laudes=`make_file $dd 1 noredir`;
    echo "$laudes";
    vesper=`make_file $dd 6 noredir`;
    [[ "${laudes/prayLaudes/prayVespera}" = "$vesper" ]] || {
      echo "$vesper"
    }
  done
  exit;
}

[[ "$debug" = 'list' ]] && {
  for dd in $dates; do
    dd=$dd-$y
    echo $dd
    for H in $(seq 0 $HORA_INDEX_LAST); do
      make_file $dd $H;
    done
  done
} || {
    y=2024
    debug=cal
    noredir=1
    make_file 07-20-$y 6;
    make_file 07-21-$y 1;
    noredir=
    debug=
    make_file 07-20-$y 6;
    MDY=07-21-$y
    for H in $(seq 0 $HORA_INDEX_LAST); do
      make_file $MDY $H;
    done
}
