{-# LANGUAGE OverloadedStrings #-}
import Prelude hiding (rem)
import Clay
import qualified Clay.Media as M
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy.IO as T
import Data.Monoid ((<>))

themeCol :: Color
themeCol = Rgba 0 0 0x28 1.0

navbar :: Css
navbar = nav ? do
    let mrgn = rem 2
    margin mrgn mrgn mrgn mrgn
    borderColor themeCol
    "border-style" -: "double"

    a ? do
        display block
        textDecoration none
        color black
        display flex
        justifyContent center
        
        let leftRightP = rem 1
        let bottomTopP = rem 0.25
        padding bottomTopP leftRightP bottomTopP leftRightP
        fontSize (rem 1.5)

    "#site-name" ? do
        background themeCol
        color white
        let bottomTopP = rem 1
        paddingBottom bottomTopP
        paddingTop bottomTopP

body_ :: Css
body_ = body ? do
    margin nil nil nil nil
    display flex
    justifyContent center

pageContent :: Css
pageContent = "main" ? do
    let lrP = rem 1
    padding nil lrP nil lrP

    ".excerpt" ? do
        borderColor gray
        borderWidth (rem 0.2)

comments :: Css
comments = "#isso-thread" ? do
    let margn = rem 2.0
    important (margin nil margn nil margn)

css :: Css
css = do
    body_
    navbar
    pageContent
    comments

-- The Clay media query thing seems kind of broken, so this is a bit of a bodge to insert a little bit of CSS
rawCss :: Text
rawCss = "@media(orientation:portrait){body{display:block;font-size:1.5rem;}}"

main :: IO ()
main = T.putStr $ renderWith compact [] css <> rawCss