#[derive(Debug)]
struct Foobar(i32);

impl Drop for Foobar {
    fn drop(&mut self) {
        println!("Dropping a Foobar: {:?}", self);
    }
}

fn uses_foobar(foobar: &Foobar) {
    println!("I consumed a Foobar: {:?}", foobar);
}

impl Foobar {
    fn use_it(&self) {
        println!("I consumed a Foobar: {:?}", self);
    }
}

fn main() {
    let x = Foobar(1);
    println!("Before uses_foobar");
    uses_foobar(&x);
    uses_foobar(&x);
    println!("After uses_foobar");
    x.use_it();
}

// Before uses_foobar
// I consumed a Foobar: 1
// I consumed a Foobar: 1
// After uses_foobar
// Dropping a Foobar: 1
