grammar Number {
    rule TOP {
        <number>
    }

    token number {
        <sign>? [
            | <integer>
            | <floating-point>
        ] <exponent>?
    }

    token sign {
        <[+-]>
    }

    token exp {
        <[eE]>
    }

    token integer {
        \d+
    }

    token floating-point {
        \d* ['.' <integer>]
    }

    token exponent {
        <exp> <sign>? <integer>
    }
}

my $n = 0;
my $sign = 1;
class NumberActions {
    method integer($/) {
        $n = $sign * +$/;
    }

    method sign($/) {
        $sign = -1 if ~$/ eq '-';
    }
}

my @cases =
    7, 77, -84, '+7', 0,
    3.14, -2.78, 5.0, '.5', '-5.3', '-.3',
    '3E4', '-33E55', '3E-3', '-1E-2',
    '3.14E2', '.5E-3',
    '', '-', '+';
for @cases -> $number {
    my $test = Number.parse($number, :actions(NumberActions));
    
    if ($test) {
        say "OK $number = $n";
    }
    else {
        say "NOT OK $number";
    }
}