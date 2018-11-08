fn main() {
    let val: String = String::from("Hello, world!");
    printer(val.clone());
    printer(val);
}

fn printer(val: String) {
    println!("The value is: {}", val);
}
