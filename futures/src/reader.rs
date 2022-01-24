use std::{
    pin::Pin,
    task::{Context, Poll}, time::Duration,
};

use tokio::{io::{AsyncRead, ReadBuf, AsyncReadExt}, fs::File, time::{Instant, Sleep}};
use futures::FutureExt;

struct SlowReader<R> {
    reader: Pin<Box<R>>,
    sleep: Pin<Box<Sleep>>
}

impl<R> SlowReader<R> {
    fn new(reader: R) -> Self {
        Self { reader: Box::pin(reader),
        sleep: Box::pin(tokio::time::sleep(Default::default()))}
    }
}

impl<R> AsyncRead for SlowReader<R>
where
    R: AsyncRead,
{
    fn poll_read(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &mut ReadBuf<'_>,
    ) -> Poll<std::io::Result<()>> {
        match self.sleep.poll_unpin(cx) {
            Poll::Ready(_) => {
                self.sleep.as_mut().reset(Instant::now() + Duration::from_millis(25));
                self.reader.as_mut().poll_read(cx, buf)
            },
            Poll::Pending => Poll::Pending,
        }
    }
}

#[tokio::main]
async fn main() -> Result<(), tokio::io::Error> {
    let mut buf = vec![0u8; 128 * 1024];
    let mut f = SlowReader::new(File::open("/dev/urandom").await?);
    let before = Instant::now();
    f.read_exact(&mut buf).await?;
    println!("Read {} bytes in {:?}", buf.len(), before.elapsed());
    Ok(())
}
