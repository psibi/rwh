fn main() {
    let condition: bool = true;
    
    if condition {
        ()
    };
    println!("Value is {}", condition);
    
    if 3 > 5 {
        println!("some side effect");
    };
    
    let g:i32 = if 10 < 20 {
        5
    } else {
        3
    };
    println!("g value, {}", g);
}
