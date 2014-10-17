# Copyright (c) 2014, Josh Filstrup
# Licensed under BSD3(see license.md file for details)
#
# An implementation of the Maybe monad for Nim
# This implements the traditional operations, bind(called chain)
# and return(called box) as well as a few useful operators for 
# cleaning up usage of the monad. Also implemented the functor
# operation fmap(called map) which allows a procedure to be called
# on a wrapped value

type
    Maybe*[T] = object
        case valid*: bool
        of true:    value* : T
        of false:   nil

# -------------------------------------------------
# ------- Operators -------------------------------
# -------------------------------------------------
proc `?`*[T](m: Maybe[T]) : bool =
    return m.valid

proc `$`*[T](m: Maybe[T]) : string =
    if ?m:
        return "Just " & $m.value
    else:
        return "Nothing"

proc `>>=`*[T,U](m: Maybe[U], p: proc(x:U): Maybe[T]) : Maybe[T] =
    if ?m:
        return p(m.value)
    else:
        return Maybe[T](valid: false)

# -------------------------------------------------
# ------- Monadic Operations ----------------------
# -------------------------------------------------
proc box*[T](val: T) : Maybe[T] =
    return Maybe[T](valid: true, value: val)

proc chain*[T,U](m: Maybe[U], p: proc(x:U): Maybe[T]) : Maybe[T] {. procvar .} =
    if ?m:
        return p(m.value)
    else:
        return Maybe[T](valid: false)

proc map*[T,U](m: Maybe[U], p: proc(x:U) : T) : Maybe[T] {. procvar .} =
    if ?m:
        return Maybe[T](valid: true, value: p(m.value))
    else:
        return Maybe[T](valid: false)
