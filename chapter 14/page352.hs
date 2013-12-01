dogetRandom :: Random a => RandomState a
dogetRandom = do
  gen <- get
  let (a, g') = random gen
  put g'
  return a
