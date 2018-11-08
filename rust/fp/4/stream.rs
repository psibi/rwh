struct Empty;

impl Iterator for Empty {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        None
    }
}

fn main() {
    for i in Empty {
        panic!("Wait, this shouldn't happen!");
    }
    println!("All done");
}
