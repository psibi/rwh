use std::env::{args, Args};
use std::iter::Skip;

fn main() {
    let args: Skip<Args> = args().skip(1);
    for arg in args {
        let num = arg.parse::<u32>();
        println!("{:?}", num);
    }
}
