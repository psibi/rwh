#[derive(Debug)]
struct Foobar(i32);

impl Drop for Foobar {
    fn drop(&mut self) {
        println!("Dropping a Foobar: {:?}", self);
    }
}

fn main() {
    println!("Before x");
    let _x = Foobar(1);
    println!("After x");
    {
        println!("Before y");
        let _y = Foobar(2);
        println!("After y");
    }
    println!("End of main");
}
