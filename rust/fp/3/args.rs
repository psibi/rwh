use std::env::Args;
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

fn require_arg(args: &mut Args) -> Result<String, ParseError> {
    match args.next() {
        None => Err(ParseError::TooFewArgs),
        Some(s) => Ok(s),
    }
}

fn require_no_args(args: &mut Args) -> Result<(), ParseError> {
    match args.next() {
        Some(_) => Err(ParseError::TooManyArgs),
        None => Ok(()),
    }
}

fn parse_u32(s: String) -> Result<u32, ParseError> {
    match s.parse() {
        Ok(n) => Ok(n),
        Err(_) => Err(ParseError::InvalidInteger(s)),
    }
}

fn parse_args() -> Result<Frame, ParseError> {
    let mut args = std::env::args();
    let _command_line = require_arg(&mut args)?;

    let width_str = require_arg(&mut args)?;
    let height_str = require_arg(&mut args)?;
    require_no_args(&mut args)?;
    let width = parse_u32(width_str)?;
    let height = parse_u32(height_str)?;
    Ok(Frame { width, height })
}
