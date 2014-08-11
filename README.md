Parsex
======
[![Build Status](https://travis-ci.org/herenowcoder/parsex.svg?branch=master)](https://travis-ci.org/herenowcoder/parsex)

Parser combinators for Elixir.

This is a work in progress. 
A go through the "monparsing" paper for now.
On the way invented yet another monad macro.

Random notes:
* return stream from parser - or only in `plus` when there's more
  than 1 item
* test via excheck
