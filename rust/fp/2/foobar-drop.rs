use std::mem;

#[derive(Debug)]
struct Foobar(i32);

impl Drop for Foobar {
    fn drop(&mut self) {
        println!("Dropping a Foobar: {:?}", self);
        mem::drop(self);
    }
}

fn uses_foobar(foobar: Foobar) {
    println!("I consumed a Foobar: {:?}", foobar);
}

fn main() {
    let x = Foobar(1);
    println!("Before uses_foobar");
    uses_foobar(x);
    println!("After uses_foobar");
}

// before uses_foobar
// I consumed a Foobar: 1
// Dropping a Foobar: 1
// After uses_foobar
