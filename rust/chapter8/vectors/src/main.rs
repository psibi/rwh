fn main() {
    // let mut v = vec![1, 2, 3, 4, 5];
    // let third: &i32 = &v[2];
    // v.push(7);

    let mut v = vec![1, 2, 3, 4, 5];
    for i in &mut v {
        *i = *i + 50;
    }
    for i in &v {
        println!("{}", i);
    }

    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }

    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Float(10.12),
        SpreadsheetCell::Text(String::from("blue")),
    ];

    // println!("Hello, world!, {}", third);
}
