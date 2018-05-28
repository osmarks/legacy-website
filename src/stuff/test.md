---
title: Markdown test page
published: 05/11/2017
slug: test
description: This probably shouldn't count. It's a test page.
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
-- Does useless nonsense
import System.Environment

addOne :: Int -> Int
addOne = (+1)

main :: IO ()
main = do
    let aNumber = addOne 12345678
    putStrLn $ show aNumber

    args <- getArgs
    putStrLn $ foldMap (++ " ") args
```

```javascript
// New Javascript framework: blah.js
function blah(a, b, c) {
    return a * b - c + b;
}

let useless = x => x + 1;

console.log(useless(blah(1, "a", undefined)))
```

```c
// Likely to be a Hello World. I don't really know C.
#include <stdio.h>

int main() {
    printf("Hello, World!");
    return 0;
}
```