:- module(buckshot, [asdf/3, pred/1]).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(my_module)).
:- op(300, fx, $).

:- det(pred/1).
:- discontiguous pred.

pred(X) :- test(X).

'this is a~n thing'(asd).

test :-
    asdf,
    format('a~tsdf~tas~`_tdf~*|', [123]),
    X = 'looks like an atom and IS an atom',
    'it looks like an atom but it\'s a functor'(asdf),
end.

end.

dcg(asdf) --> [].

numbers :-
    X = 1r2 + -3r5 + -2.421e-45 - .34,
    Y = 0's + 0'' + 0'$ + 0'Q + 0': + 0'\x2F\ + 0'\uBEEF.

0 <++> 0 :- Lhs = Rhs.
Lhs <++> Rhs :- Lhs = Rhs.

append([], X, X).
append([X|Xs], Ys, [X|XsYs]) :-
    append(Xs, Ys, XsYs).

languages :-

    prolog,

    X = {|html(X)||
        <html>
        <script>
            function asdf() {
                return 123;
            }
        </script>
        <body>
            <h1>Welcome!</h1>
        </body>
        </html>
    |}

    true.

html :-
    {|html(Person)||<p>Hello, Person</p>|},
    end.

