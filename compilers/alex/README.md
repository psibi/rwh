## Alex

### Instructions on running [./Token.x](Token.x)

* stack ghc Token.x
* ./Token

``` shellsession
~/g/r/c/alex (master) $ ./Token
33
hello
let
[Int 33,Var "hello",Let]
```

### Introduction

Alex is similar to flex in the C/C++ land. It takes a description of tokens based on regular expressions.

### Macro definitions

$digit = 0-9
$alpha = [a-zA-Z]
