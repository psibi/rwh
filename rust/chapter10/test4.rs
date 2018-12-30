struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x);
}
