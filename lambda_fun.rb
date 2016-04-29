def to_natural(number, numeral: $zero)
  return numeral if number == 0
  to_natural(number-1, numeral: S[numeral])
end
ToRubyNumber = ->n{
  If[IsZero[n]][
    ->_{ 0 }
  ][
    ->_{ 1 + ToRubyNumber[P[n]] }
  ]
}
def from_char(character)
  to_natural character.ord
end
def print_char(n)
  STDOUT <<  ToRubyNumber[n].chr
end
PrintChar = ->chr{
  First[MakePair[chr][print_char chr]]
}
I = ->x{ x }
K = ->x{->y{ x }}

GetFirst = K
GetSecond = K[I]

True = GetFirst
False = GetSecond
If = ->boolean{->if_true{->if_false{
  boolean[if_true][if_false].(I)
}}}

Not = ->boolean{
  If[boolean][
    ->_{ False }
  ][
    ->_{ True }
  ]
}

Assert = ->boolean{
  If[boolean][->_{ PrintChar[from_char("T")]}][->_{ PrintChar[from_char("F")]}]
}
Refute = ->boolean{
  Assert[Not[boolean]]
}


MakePair = ->first{->second{
  ->picker{
    picker[first][second]
  }
}}

First = ->pair{
  pair[GetFirst]
}
Last = ->pair{
  pair[GetSecond]
}

$zero =  MakePair[True][I]
IsZero = ->n{
  First[n]
}
S = ->n{
  MakePair[False][n]
}
P = ->n{
  Last[n]
}

NumbersEquals = ->first{->second{
  If[IsZero[first]][
    ->_{ IsZero[second] }
  ][
    ->_{
      If[IsZero[second]][
        ->_{ False }
      ][
        ->_{
          NumbersEquals[P[first]][P[second]]
        }
      ]
    }
  ]
}}


$one = S[$zero]
Assert[IsZero[$zero]]
Assert[NumbersEquals[$zero][$zero]]
Assert[NumbersEquals[S[$zero]][S[$zero]]]

Refute[IsZero[S[$zero]]]
Refute[NumbersEquals[$zero][S[$zero]]]
Refute[NumbersEquals[S[$zero]][$zero]]

$two = S[$one]
Assert[NumbersEquals[$two][$two]]
Refute[NumbersEquals[$two][$one]]


# LISTS


$emptylist = MakePair[True][I]
MakeList = ->item{->list{
  MakePair[False][MakePair[item][list]]
}}
Compose = ->func1{->func2{
  ->item{
    func1[func2[item]]
  }
}}
Head = Compose[First][Last]
Tail = Compose[Last][Last]
IsEmptyList = First

$list_one = MakeList[$one][$emptylist]
$list_two_one = MakeList[$two][$list_one]
Assert[IsEmptyList[$emptylist]]
Refute[IsEmptyList[$list_one]]

Assert[NumbersEquals[$one][Head[$list_one]]]
Assert[IsEmptyList[Tail[$list_one]]]

Assert[NumbersEquals[$two][Head[$list_two_one]]]
Assert[NumbersEquals[$one][Head[Tail[$list_two_one]]]]
Assert[IsEmptyList[Tail[Tail[$list_two_one]]]]

Map = ->function{->list{
  If[IsEmptyList[list]][
    ->_{ list }
  ][
    ->_{
      MakeList[function[Head[list]]][Map[function][Tail[list]]]
    }
  ]
}}

Assert[IsEmptyList[Map[S][$emptylist]]]

$list_s_one = Map[S][$list_one]
Assert[NumbersEquals[$two][Head[$list_s_one]]]

$three = S[$two]
$list_s_two_one = Map[S][$list_two_one]
Assert[NumbersEquals[$three][Head[$list_s_two_one]]]
Assert[NumbersEquals[$two][Head[Tail[$list_s_two_one]]]]
Assert[IsEmptyList[Tail[Tail[$list_s_two_one]]]]


$hello = MakeList[from_char('h')][
  MakeList[from_char('e')][
    MakeList[from_char('l')][
      MakeList[from_char('l')][
        MakeList[from_char('o')][
          MakeList[from_char(',')][
            MakeList[from_char(' ')][
              MakeList[from_char('m')][
                MakeList[from_char('a')][
                  MakeList[from_char('g')][
                    MakeList[from_char('y')][
                      MakeList[from_char('a')][
                        MakeList[from_char('r')][
                          MakeList[from_char('o')][
                            MakeList[from_char('k')][
                              MakeList[from_char('!')][
                                $emptylist
]]]]]]]]]]]]]]]]


#Map[PrintChar][$hello]

PrintList = Map[PrintChar]

PrintList[$hello]
