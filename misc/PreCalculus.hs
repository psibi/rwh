data Angle = Angle {
  degree :: Degree,
  minutes :: Minutes,
  seconds :: Seconds
  } deriving (Show)

type Degree = Double
type Minutes = Double
type Seconds = Double

angletoDegree :: Angle -> Degree
angletoDegree a = degree a + (minutes a / 60.0) + (seconds a / 3600.0)

degreetoAngle :: Degree -> Angle
degreetoAngle d = Angle (fromIntegral d') (60.0 * m) (60.0 * s)
  where (d',m) = properFraction d
        s = snd $ properFraction (60 * m)

a = Angle 5 25 37

newtype Radian = Radian Double deriving (Show)
