Type of parameters:

fn foo(age: u32) {}
fn foo1(mut age: u32) {}

The caller of the function will move the `age` value into the function (regardless of mutability).

fn baz(age: &u32) {}
fn bin(age: &mut u32) {}

# Copy trait

The types implementing `Copy` trait can be assigned to without any compile errors:

```
fn main() {
    let x: u32 = 3;
    let y = x;
    println!("hello world {}", x);
}
```

The above code compiles fine as compared to this which throws compile errors:

```
fn main() {
    let x: String = String::from("world");
    let y = x;
    println!("hello {}", x);
}
```

# Other points

* Unlike tuples and built in array, collections like vector, hashmap and string are stored in the heap.
* Unlike functions, closures can capture values from the scope in which they're defined.

# Other Resources

* [Rust Cheat Sheet](https://cheats.rs/)
