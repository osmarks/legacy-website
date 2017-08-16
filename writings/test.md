# Markdown rendering test page
This page contains a bit of Markdown plus some code snippets in order to test serverside markdown rendering & clientside syntax highlighting.

## This is a smaller header
### Smaller
#### Even smaller
##### Is this even a header?
###### In order to view this header an electron microscope is reccomended

*italic* **bold** ***both***

----

~~~~
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
~~~~

~~~~
open System.Blahblah

[<EntryPoint>]
let main argv =
    printfn "%A" argv
    printfn "Hello world!"
    0
~~~~

~~~~
function blah(a, b, c) {
    return a * b - c + b;
}

let useless = x => x + 1;

console.log(useless(blah(1, "a", undefined)))
~~~~