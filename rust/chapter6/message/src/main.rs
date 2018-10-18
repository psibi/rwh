use std::fmt::Display;

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

enum UsState {
    Alabama,
    Alaska,
    Texas,
}

impl Display for UsState {
    fn fmt(self: &Self, fmt: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        let state = match self {
            UsState::Alabama => "Alabama",
            UsState::Alaska => "Alaska",
            UsState::Texas => "Texas",
        };
        write!(fmt, "Us State {}", state)
    }
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

fn value_in_cents(coin: Coin) -> u32 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 25,
        Coin::Quarter(state) => {
            println!("Your state is {}", state);
            20
        }
    }
}

fn main() {
    println!(
        "Hello, world! {}",
        value_in_cents(Coin::Quarter(UsState::Alabama))
    );
}
