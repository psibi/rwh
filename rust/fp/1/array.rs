fn test(u: usize) -> i32 {
    let arr = [1,2,3];
    arr[u - 2]
}

fn main() {
    println!("hello world {}", test(1));
}
