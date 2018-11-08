fn fizzbuzz(num: u32) {
    if (num % 15 == 0) {
        println!("Fizzbuzz");
    } else if (num % 3 == 0) {
        println!("Fizz");
    } else if (num % 5 == 0) {
        println!("Buzz");
    } else {
        println!("{}", num);
    }
}

fn main() {
    fizzbuzz(45);
    fizzbuzz(102);
    fizzbuzz(105);
    fizzbuzz(120);
}
