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

struct ParseArgs(std::env::Args);

impl ParseArgs {
    fn new() -> ParseArgs {
        ParseArgs(std::env::args())
    }

    fn require_arg(&mut self) -> Result<String, ParseError> {
        match self.0.next() {
            None => Err(ParseError::TooFewArgs),
            Some(s) => Ok(s),
        }
    }

    fn require_no_args(&mut self) -> Result<(), ParseError> {
        match self.0.next() {
            Some(_) => Err(ParseError::TooManyArgs),
            None => Ok(()),
        }
    }
}

fn parse_u32(s: String) -> Result<u32, ParseError> {
    match s.parse() {
        Ok(n) => Ok(n),
        Err(_) => Err(ParseError::InvalidInteger(s)),
    }
}

fn parse_args() -> Result<Frame, ParseError> {
    let mut args = ParseArgs::new();

    // skip the command name
    args.require_arg()?;

    let width_str = args.require_arg()?;
    let height_str = args.require_arg()?;
    args.require_no_args()?;
    let width = parse_u32(width_str)?;
    let height = parse_u32(height_str)?;

    Ok(Frame { width, height })
}

fn main() {
    println!("{:?}", parse_args());
}
