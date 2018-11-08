#[derive(Debug)]
struct Foobar(i32);

fn main() {
    let x = Foobar(1);

    let mut y = Foobar(2);

    bar(&y);
    bar(&y); // compile error - no two mutuable references
}

// read only reference
fn bar(_foobar: &Foobar) {}
