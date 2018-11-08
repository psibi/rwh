#[derive(Debug)]
struct Foobar(i32);

fn main() {
    let x = Foobar(1);

    foo(x);
    foo(x); // compile error

    let mut y = Foobar(2);

    bar(&y);
    bar(&y); // compile error - no two mutuable references

    let z = &mut y;
    bar(&y);
    baz(&mut y);
    baz(z);
}

// move
fn foo(_foobar: Foobar) {}

// read only reference
fn bar(_foobar: &Foobar) {}

// mutable reference
fn baz(_foobar: &mut Foobar) {}
