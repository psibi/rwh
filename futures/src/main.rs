use std::{future::Future, pin::Pin, task::{Context, Poll}, time::Duration};

use tokio::time::Sleep;

#[tokio::main(flavor="current_thread")]
async fn main() {
    let future = MyFuture::new();
    println!("Awaiting fut...");
    future.await;
    println!("Awaiting fut... done!");
}

struct MyFuture {
    sleep: Sleep
}

impl Future for MyFuture {
    type Output = ();

    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        println!("MyFuture::poll");
        // self.sleep.poll(cx) does work because
        // self.sleep : Sleep
        // But the poll function can be only be call when self itself is pinned because `mut self: Pin<&mut Self>`
        self.sleep.poll(cx)
    }
}
impl MyFuture {
    fn new() -> Self {
        Self {sleep: tokio::time::sleep(Duration::from_secs(1))}
    }
}
