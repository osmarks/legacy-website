{-# LANGUAGE OverloadedStrings #-}
import Hakyll
import Data.Monoid ((<>))
import System.FilePath.Posix
import System.Directory
import Data.List (intercalate)

main :: IO ()
main = hakyll $ do
    match "templates/*" $ compile templateBodyCompiler

    match "assets/style/*" $ do
        route idRoute
        compile compressCssCompiler

    match "assets/images/*" passthrough
    match "assets/js/*" passthrough

    match "assets/*.html" $ inDefaultTemplate

    match "writings/**.md" $ do
        route $ setExtension "html" `composeRoutes` toSlug
        compile mdCompile
    match "**index.md" $ route (setExtension "html") >> compile mdCompile

    match "experiments/**.html" $ inDefaultTemplateR removeFirstPart
    match "experiments/**" $ passthroughR removeFirstPart

    match "errors/**" inDefaultTemplate

    match "go-to-root/**" $ do
        route $ customRoute (takeFileName . toFilePath)
        compile copyFileCompiler

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

    create ["sitemap.json"] $ do
        route idRoute
        compile $
            unsafeCompiler (serializeFSTree <$> getFSTree "_site/")
            >>= makeItem

data FSTree = File FilePath | Directory FilePath [FSTree] deriving (Show, Eq)

-- Converts a FSTree to JSON using string concatenation
-- TODO if this gets more complex: Use Aeson
serializeFSTree :: FSTree -> String
serializeFSTree (File path) = "\"" ++ path ++ "\""
serializeFSTree (Directory path subtrees) = "{\"path\":\"" ++ path ++ "\", \"contents\":[" ++ (intercalate "," $ fmap serializeFSTree subtrees) ++ "]}"

-- Make a FSTree from all the files/directories in a directory
getFSTree :: FilePath -> IO FSTree
getFSTree root =
    go root ""
        where
        go root name = do
            let actual = root </> name
            putStrLn name
            putStrLn root
            putStrLn actual
            isDir <- doesDirectoryExist actual

            if isDir then do
                listing <- listDirectory actual
                subtree <- mapM (go actual) listing
                return $ Directory name subtree
            else
                return $ File name

writingsGlob :: Pattern
writingsGlob = "writings/*.md"

mdCompile :: Compiler (Item String)
mdCompile = pandocCompiler 
    >>= saveSnapshot "content"
    >>= loadAndApplyTemplate "templates/default.html" context
    >>= relativizeUrls

-- Just copy the file into the given route
passthroughR :: Routes -> Rules ()
passthroughR r = route r >> compile copyFileCompiler

passthrough :: Rules ()
passthrough = passthroughR idRoute

-- Applies the default template to a resource, and applies the supplied route to it
inDefaultTemplateR :: Routes -> Rules ()
inDefaultTemplateR r = route r >> compile (getResourceBody >>= loadAndApplyTemplate "templates/default.html" context)

inDefaultTemplate :: Rules ()
inDefaultTemplate = inDefaultTemplateR idRoute

-- Base context for where context is used
context :: Context String
context = defaultContext

-- Removes the first part from a path ("/abcd/efgh" -> "/efgh")
removeFirstPart :: Routes
removeFirstPart = customRoute (joinPath . tail . splitPath . toFilePath)

-- Gives a file a clean name and puts it at the webroot
toSlug :: Routes
toSlug = customRoute (indexAndMove . toFilePath)
    where
        indexAndMove p = takeBaseName p </> "index.html"

feedConf :: FeedConfiguration
feedConf = FeedConfiguration
    { feedTitle       = "osmarks.ml stuff"
    , feedDescription = "The latest Stuff from osmarks.ml!"
    , feedAuthorName  = "Oliver Marks"
    , feedAuthorEmail = "osmarks@protonmail.com"
    , feedRoot        = "https://osmarks.ml"
    }