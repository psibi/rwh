use std::fmt::Display;

What happ

struct MyType;

impl Display for MyType {

}

fn main() {
    println!("hello world { }", MyType);
}
