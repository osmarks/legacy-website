// infiscroll.js
// A really simple infinite-scroll system.
// Places an invisible marker element near the bottom of the screen and adds new content until it's offscreen.
// Available under the Mozilla Public License v2.0 (https://www.mozilla.org/en-US/MPL/2.0/).

function elInViewport(el) {
	var rect = el.getBoundingClientRect();

    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
}

function addMarker(markerPos) {
    var markerPos = markerPos || "5vh";

    var el = document.createElement("div");
    el.style.position = "absolute";
    el.style.bottom = markerPos;
    el.style.width = "1px";
    el.style.height = "1px";

    document.body.appendChild(el);

    return el;
}

function infiscroll(addNewContent, markerPos, maximumTries) {
    var marker = addMarker(markerPos);
    var maximumTries = maximumTries || 10;

    window.onscroll = function() {
        var i = 0;

        while (elInViewport(marker) && i < maximumTries) {
            addNewContent();
            console.log(i)
            i++;
        }
    }

    window.onscroll();
}