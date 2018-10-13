fn main() {
    
    struct User {
        username: String,
        email: String,
        sign_in_count: u64,
        active: bool,
    }
    
    let user1 = User {
        email: String::from("sibi@psibi.in"),
        username: String::from("sibi"),
        active: true,
        sign_in_count: 1,
    };
    
    println!("Hello, world! {}", user1.email);
}
