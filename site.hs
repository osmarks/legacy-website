{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
import Data.Monoid ((<>))
import Hakyll
import Control.Monad (liftM)
import Data.List (intersperse, sortBy)
import Data.Ord (comparing)
import System.FilePath

main :: IO ()
main = hakyllWith config $ do
    match "blog/*.md" $ do
        route niceURL
        compile compileMarkdown

    match "**.md" $ do
        route $ setExtension "html"
        compile compileMarkdown
    
    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx =
                    listField "experiments" ctx experiments <>
                    listField "blog" ctx blog <>
                    constField "title" "Home" <>
                    ctx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match ("experiments/**.html") $ route removeFirstPartR >> compile compileHTML
    match ("experiments/**") $ route removeFirstPartR >> compile copyFileCompiler

    match "**.css" $ do
        route idRoute
        compile compressCssCompiler

    match ("**.html" .&&. complement templates) $ do
        route idRoute
        compile compileHTML

    match "assets/css/*.hs" $ do
        route $ setExtension "css"
        compile $ getResourceBody >>= withItemBody (unixFilter "stack" ["runghc"])
    
    match "assets/**" $ do
        route idRoute
        compile copyFileCompiler

    match templates $ compile templateBodyCompiler

    create ["rss.xml"] $ do
        route idRoute
        compile $ renderRss feedConf ctx =<< allContent

niceURL :: Routes
niceURL = customRoute (indexAndMove . toFilePath)
    where
        indexAndMove p = takeBaseName p </> "index.html"
        

experiments :: Compiler [Item String]
experiments = loadAll "experiments/**.html" >>= recentFirst'

blog :: Compiler [Item String]
blog = loadAll "blog/*" >>= recentFirst'

allContent :: Compiler [Item String]
allContent = do
    blg <- blog
    exp <- experiments
    recentFirst' (blg ++ exp)

compileHTML :: Compiler (Item String)
compileHTML = getResourceBody >>= loadAndApplyTemplate "templates/default.html" (teaserField "teaser" "content" <> ctx) >>= relativizeUrls

compileMarkdown :: Compiler (Item String)
compileMarkdown = pandocCompiler
    >>= loadAndApplyTemplate "templates/post.html"    ctx
    >>= loadAndApplyTemplate "templates/default.html" ctx
    >>= relativizeUrls

removeFirstPart :: FilePath -> FilePath
removeFirstPart = joinPath . tail . splitPath

removeFirstPartR :: Routes
removeFirstPartR = customRoute (removeFirstPart . toFilePath)

templates :: Pattern
templates = "templates/*"

-- Modified versions of the actual Hakyll "chronological"/"recentFirst" functions which use file modification time
chronological' :: [Item a] -> Compiler [Item a]
chronological' =
    sortByM $ getItemModificationTime . itemIdentifier
  where
    sortByM :: (Monad m, Ord k) => (a -> m k) -> [a] -> m [a]
    sortByM f xs = liftM (map fst . sortBy (comparing snd)) $
                   mapM (\x -> liftM (x,) (f x)) xs

recentFirst' :: [Item a] -> Compiler [Item a]
recentFirst' = liftM reverse . chronological'

ctx :: Context String
ctx =
    modificationTimeField "short-date" "%m/%d/%Y" <>
    modificationTimeField "unix-time" "%s" <>
    modificationTimeField "published" "%Y-%m-%d" <> -- these are for RSS generation
    modificationTimeField "updated" "%Y-%m-%d" <>
    constField "site-name" "Oliver's Website" <>
    defaultContext

feedConf :: FeedConfiguration
feedConf = FeedConfiguration
    { feedTitle = "osmarks.tk feed"
    , feedDescription = "Random Stuff, Subscribable To"
    , feedAuthorName = "Oliver Marks"
    , feedAuthorEmail = "osmarks@protonmail.com"
    , feedRoot = "https://osmarks.tk/"
    }

config :: Configuration
config = defaultConfiguration
    { deployCommand = "rsync --delete -vrzle ssh _site/* osmarkstk:/data/web"
    }