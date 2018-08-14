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
    let pad = rem 1
    padding pad pad pad pad

    a ? do
        textDecoration none
        color white
        fontSize (rem 2)
        display flex
        justifyContent center
        alignItems center

    background themeCol
    display flex
    justifyContent spaceAround

body_ :: Css
body_ = body ? do
    margin nil nil nil nil

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
    h4 ? textAlign center

css :: Css
css = do
    body_
    navbar
    pageContent
    comments

-- The Clay media query thing seems kind of broken, so this is a bit of a bodge to insert a little bit of CSS
rawCss :: Text
rawCss = "@media(max-width:1000px){body{display:block;font-size:1.2rem;}nav{display:block}}"

main :: IO ()
main = T.putStr $ renderWith compact [] css <> rawCss
