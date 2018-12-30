struct Test<'a> {
    foo: &'a str,
}

fn main() {
    let hi: &'static str = "hello";
    println!("hello world!");
}
