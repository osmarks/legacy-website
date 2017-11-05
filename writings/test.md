---
title: Markdown test page
published: 05/11/2017
---
This page contains a bit of Markdown plus some code snippets in order to test my Markdown handling.

## This is a smaller header
### Smaller
#### Even smaller
##### Is this even a header?
###### In order to view this header an electron microscope is reccomended

*italic* **bold** ***both***

----

```haskell
import Data.List (nub)
import System.Environment

addOne :: Int -> Int
addOne = (+1)

main :: IO ()
main = do
    let aNumber = addOne 12345678
    putStrLn $ show aNumber

    args <- getArgs
    putStrLn $ nub $ foldMap (++ " ") args
```

```F#
open System.Blahblah

[<EntryPoint>]
let main argv =
    printfn "%A" argv
    printfn "Hello world!"
    0
```

```javascript
function blah(a, b, c) {
    return a * b - c + b;
}

let useless = x => x + 1;

console.log(useless(blah(1, "a", undefined)))
```