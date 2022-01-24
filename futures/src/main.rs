use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll},
    time::Duration,
};

use futures::FutureExt;
use tokio::time::{sleep, Sleep};

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let future = MyFuture::new();
    println!("Awaiting fut...");
    future.await;
    println!("Awaiting fut... done!");
}

struct MyFuture {
    sleep: Pin<Box<Sleep>>,
}

impl Future for MyFuture {
    type Output = ();

    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        println!("MyFuture::poll");
        // self.sleep.poll(cx) does not work becausse
        // self.sleep : Sleep
        // But the poll function can be only be call when self itself is pinned because `mut self: Pin<&mut Self>`
        self.sleep.poll_unpin(cx)
    }
}
impl MyFuture {
    fn new() -> Self {
        Self {
            sleep: Box::pin(sleep(Duration::from_secs(1))),
        }
    }
}
