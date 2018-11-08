#[derive(Debug, Clone)]
struct Foobar(i32);

impl Drop for Foobar {
    fn drop(&mut self) {
        println!("Dropping: {:?}", self);
    }
}

fn uses_foobar(foobar: Foobar) {
    println!("I consumed a Foobar: {:?}", foobar);
}

fn main() {
    let x = Foobar(1);
    uses_foobar(x.clone());
    uses_foobar(x.clone());
}

// I consumed a Foobar: 1
// Dropping: 1
// I consumed a Foobar: 1
// Dropping: 1
// Dropping: 1
