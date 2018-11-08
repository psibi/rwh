#[derive(Debug)]
struct Foobar(i32);

fn main() {
    let x = Foobar(1);

    let mut y = Foobar(2);
    let z = &mut y;

    // bar(&y);

    baz(&mut y);
    baz(z);
}

// read only reference
fn bar(_foobar: &Foobar) {}

// mutable reference
fn baz(_foobar: &mut Foobar) {}
