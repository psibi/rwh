use std::{
    pin::Pin,
    task::{Context, Poll},
    time::Duration,
};

use futures::FutureExt;
use tokio::{
    fs::File,
    io::{AsyncRead, AsyncReadExt, ReadBuf},
    time::{Instant, Sleep},
};

struct SlowReader<R> {
    reader: R,
    sleep: Sleep,
}

impl<R> SlowReader<R> {
    fn new(reader: R) -> Self {
        Self {
            reader,
            sleep: tokio::time::sleep(Default::default()),
        }
    }
}

impl<R> AsyncRead for SlowReader<R>
where
    R: AsyncRead + Unpin,
{
    fn poll_read(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
        buf: &mut ReadBuf<'_>,
    ) -> Poll<std::io::Result<()>> {
        let mut sleep = unsafe { self.as_mut().map_unchecked_mut(|this| &mut this.sleep) };
        match sleep.poll_unpin(cx) {
            Poll::Ready(_) => {
                let sleep = unsafe { self.as_mut().map_unchecked_mut(|this| &mut this.sleep) };
                sleep.reset(Instant::now() + Duration::from_millis(25));
                let reader = unsafe { self.as_mut().map_unchecked_mut(|this| &mut this.reader) };
                reader.poll_read(cx, buf)
            }
            Poll::Pending => Poll::Pending,
        }
    }
}

#[tokio::main]
async fn main() -> Result<(), tokio::io::Error> {
    let mut buf = vec![0u8; 128 * 1024];
    let mut f = SlowReader::new(File::open("/dev/urandom").await?);
    let before = Instant::now();
    let mut f = unsafe { Pin::new_unchecked(&mut f) };
    f.read_exact(&mut buf).await?;
    println!("Read {} bytes in {:?}", buf.len(), before.elapsed());
    Ok(())
}
