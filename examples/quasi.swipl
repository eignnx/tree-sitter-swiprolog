languages(Content) :-
    prolog,
    X = {|html(Content)||
        <html>
        <script>
            function asdf(x) {
                return 123 + x;
            }
        </script>
        <style>
        .section > p[attr="value"] {
            color: red;
        }
        </style>
        <body>
            <h1>Welcome!</h1>
            <p>
                Here's a <a href="http://asdf.com">link</a> to a website.
            </p>
            <div>Content</div>
        </body>
        </html>
    |},

    Y = {|c||
    int main(int argc, char **argv) {
        if (argc < 2) {
            printf("asdf%s\n", "asdf");
        }
        return 0;
    }
    |},


    Z = {|rust||
    fn main() -> ! {
        let x = 123;
        panic!();
    }
    |},

    true.

html :-
    {|html(Person)||<p>Hello, Person</p>|},
    end.

