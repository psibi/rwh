# Unicode

* [Introduction resource](https://unicodebook.readthedocs.io/unicode.html)
* [Planes in Unicode](https://en.wikipedia.org/wiki/Plane_(Unicode))
* [UTF - 16](https://en.wikipedia.org/wiki/UTF-16)
* [Hex to decimal converter](https://www.rapidtables.com/convert/number/hex-to-decimal.html)

## Repl

``` haskell
λ> :set -XBinaryLiterals
λ> '\x41'
'A'
λ> :t '\x41'
'\x41' :: Char
λ> let x = 0x01
λ> :t x
x :: Num p => p
λ> let x = 0x01 :: Word16
λ> x `shiftL` 8
256
λ> x `shiftR` 8
0
λ
```

Reference: [Bit manipulation](https://stackoverflow.com/questions/6385792/what-does-a-bitwise-shift-left-or-right-do-and-what-is-it-used-for)

# Analysis of above manipulation in REPL

    +-----+----------------+
    |Hex  |Binary          |
    +-----+----------------+
    |0x01 |0000000000000001|
    +-----+----------------+

# shiftL 8

* Add eight zeros to the endmost of it by shifting it.
* That results in 0000000100000000                    
                  
In repl:          

``` haskell
λ> let y = 0b0000000100000000 :: Word16
λ> y
256
```

Mathematically, 

1 left shift = num * 2
2 left shift = num * 4
   
# shiftR 8
   
* Add eight zeros to the beginning of it by shifting it.
* This results in 0000000000000000
   
In repl:
   
``` haskell
λ> let y = 0b0000000000000000 :: Word16
λ> y                 
0
```
                     
Mathematically,

1 right shift = num / 2
2 right shift = num / 4

