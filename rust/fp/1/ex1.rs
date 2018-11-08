fn main() {
    let val: String = String::from("Hello, world!");
    printer(&val);
    printer(&val);
}

// Question: Difference between these two functions
// fn printer(val: &str) {
//     println!("The value is {}", val)
// }

// and
// fn printer(val: &String) {
//     println!("The value is {}", val)
// }

// This doesn't work
// fn printer(&val) {
//     println!("The value is {}", val)
// }

fn printer(val: &String) {
    println!("The value is {}", val)
}
