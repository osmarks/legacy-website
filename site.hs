{-# LANGUAGE OverloadedStrings #-}
import Hakyll
import Data.Monoid ((<>))

main :: IO ()
main = hakyll $ do
    match "templates/*" $ compile templateBodyCompiler

    match "assets/js/*" passthrough

    match "assets/style/*" $ do
        route idRoute
        compile compressCssCompiler

    match "assets/images/*" passthrough

    match "**.md" $ do
        route $ setExtension "html"
        compile $ 
            pandocCompiler 
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" context
            >>= relativizeUrls

    match "experiments/**.html" inDefaultTemplate

    match "experiments/**" passthrough

    match "errors/**" inDefaultTemplate

    create ["writings/index.html"] $ do
        let pages = loadAll writingsGlob
        let ctx = listField "pages" context pages <> constField "title" "Writings" <> context

        route idRoute
        compile $
            makeItem ""
            >>= loadAndApplyTemplate "templates/listing.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            let feedContext = context <> bodyField "description" <> dateField "date" "dd/mm/yyyy" <> constField "updated" "???"
            stuff <- loadAllSnapshots writingsGlob "content"
            renderRss feedConf feedContext stuff

allContent :: Pattern
allContent = fromList ["writings/**", "experiments/**"]

writingsGlob :: Pattern
writingsGlob = "writings/*.md"

passthrough :: Rules ()
passthrough = route idRoute >> compile copyFileCompiler

inDefaultTemplate :: Rules ()
inDefaultTemplate = route idRoute >> compile (getResourceBody >>= loadAndApplyTemplate "templates/default.html" context)

context :: Context String
context = defaultContext

feedConf :: FeedConfiguration
feedConf = FeedConfiguration
    { feedTitle       = "osmarks.ml stuff"
    , feedDescription = "The latest Stuff from osmarks.ml!"
    , feedAuthorName  = "Oliver Marks"
    , feedAuthorEmail = "osmarks@protonmail.com"
    , feedRoot        = "https://osmarks.ml"
    }