#[derive(Debug)]
struct Frame {
    width: u32,
    height: u32,
}

#[derive(Debug)]
enum ParseError {
    TooFewArgs,
    TooManyArgs,
    InvalidInteger(String),
}

fn parse_args() -> Result<Frame, ParseError> {
    use self::ParseError::*;
    let mut args = std::env::args().skip(1);
    
    match args.next()
}
