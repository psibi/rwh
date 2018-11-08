fn factorial(i: u32) -> u32 {
    if (i == 0 || i == 1) {
        1
    }
    else {
        i * factorial(i - 1)   
    }
}

fn main() {
    println!("Factorial code {}", factorial(50000));
}
