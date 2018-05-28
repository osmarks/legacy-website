let Metalsmith  = require("metalsmith");
let markdown    = require("metalsmith-markdown");
let permalinks  = require("metalsmith-permalinks");
let layout      = require("metalsmith-layouts");
let stylus      = require("metalsmith-stylus");
let collections = require("metalsmith-collections");
let feed        = require("metalsmith-feed");
let sitemap     = require("metalsmith-mapsite");
let ss          = require("metalsmith-simple-search");

let m = Metalsmith(__dirname)
  .metadata({ // This metadata will be the default for pages, so set relatively sane defaults here.
    title: "Untitled",
    description: "",
    site: {
      title: "Oliver's Website",
      url: "https://osmarks.ml/"
    }
  })
  .source("./src")
  .destination("./build")
  .clean(false)
  .use(stylus())
  .use(markdown({
    langPrefix: "" // for highlight.js
  }))
  .use(collections({
    blog: {
      "pattern": "stuff/**",
      "metadata": {
        "title": "Blog(ish)",
        "description": "Where I write about stuff (and things)."
      }
    },
    experiments: {
      "pattern": "experiments/**",
      "metadata": {
        "title": "Experiments",
        "description": "Whimsical Uselessness."
      }
    }
  }))
  .use(permalinks({
    "pattern": ":slug",
    "relative": false
  }))
  .use(layout({
    "engine": "pug",
    "directory": "./templates",
    "default": "page.pug",
    "pattern": "**/*.html"
  }))
  .use(feed({
    collection: "blog"
  }))
  .use(feed({
    collection: "experiments", 
    destination: "experiments.rss.xml"
  }))
  .use(ss({
    match: "**/*.{html,txt}"
  }))
  .use(sitemap("https://osmarks.ml/"))

if (module.parent) {
  module.exports = m;
} else {
  m.build(function(err, files) {
    if (err) { throw err; }
  });
}