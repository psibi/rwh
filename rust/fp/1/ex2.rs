fn main() {
    let mut i = 1;

    loop {
        println!("i == {}", i);
        if i >= 10 {
            break;
        } else {
            i += 1;
        }
    }
}
