<?php
include('/dat/www/markdown.php');
$md = Markdown(file_get_contents($_SERVER['DOCUMENT_ROOT'] . $_SERVER['SCRIPT_NAME']));
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <!--# include virtual="/header.html" -->
    <meta description="This is a Markdown page containing stuff and things.">
    <link rel="stylesheet" href="/assets/styles-highlight/railscasts.css">
    <meta charset="UTF-8">
</head>
<body>
    <!--# include virtual="/navbar.html" -->
    <div class="main-content">
        <?php echo $md; ?>
        <a href="<?php echo $_SERVER['SCRIPT_NAME'] . "/raw" ?>">Raw Markdown file</a>
    </div>

    <script src="/assets/js/highlight.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
</body>
</html>
