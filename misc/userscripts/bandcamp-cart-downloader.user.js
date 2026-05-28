// ==UserScript==
// @name        bandcamp-cart-downloader
// @namespace   Violentmonkey Scripts
// @icon        data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACxUlEQVRYR+1WPWhTURS+576YtBUpBWuaShdFFIqIwSpJClZ0tEMFo6BJHMS6OHXRrZsO4qCL0sUkDhrBDnVUrJAfi6GKUFDEqdgkRFARtYl593ruS+6zMWny4N3QpXfJ7z3n+77znXcOkA0+sMH5ySYAywqcTnCt2K9Wsf4i4ZYAcM4BD++EXywBGHvBHe+XMxMUWC/jUEEdLN1rBRg5UYy32jKQkP1xEHR3NH2SEDZHCDBCOLWvRDUOqnqnLRMhvyeWfsUJP4wXyvhqDwAXpeRbkMzHrd2ukXUBSPYD0UyEE/0+iq4TTjTb7GtxKKWXcyH/vaYApOkG57I97GtpET/vVSO/WcJ327v7RpaCw+WmAITp5o9BZSCWmsLkN5F9Bdk7VLEHqp3Jh3wJoXIDAMneHUvtwFq9xcQeIloQvWALQE169NHLfDgwJvM0BJXsPbHkdcbJVXXsqyQcGj3x+bz/ufRYHYBpzuk0ABt6mNpdLpE3qMA2lexRwdlCZPSUzCMUrQPwr+9TM5j8ojLnVzNVNNCOrIR8i00ByC8H4xmvzvUFJaarJq62L8BMIRy4JElKP5kKSADuaPIJ/jihhL1pXvjhdJGDy2cDn9ayN0sgUe18kD5e0dkzNT1flV0oSYHcyIVHr0mDr+0mQwHZEtj38/j+qFL2QHLQ1XMgH/QWm01VMB+58UyQM/2RkuQ10xnsCUzlIoFbzdibJRhOLDm/rH7LohT71chvTrsPtM/lXRk/9Gu9ncIogSeenmSM3VXI3nA+EO1CPuKL/u/8Og/sSmR7f/4uvUYn7EH2fwjYe+TirsKQrROALORCAV+7TQrQeLfxwhU10gvny7lBxwsR/9NW7A0PeOLJc4zTLryHW4rNI7YV4A6M933fkG9WTNR2Ee1NuBbRrS6yRht2Yt0Wu2Q79g3DyMoF1f/pWAmsAt0E8Bd7KHXFIBOOFQAAAABJRU5ErkJggg==
// @version     1.0.0
//
// @match       https://bandcamp.com/download*
// @grant       none
//
// @author      Max Audron <me@audron.dev>
// @description Copy all download URLs from a bandcamp cart page to your clipboard, one url per line so it can be used in your own scripts to download them all.
//
// @run-at document-end
// ==/UserScript==

const myButton = document.createElement("button");

myButton.innerText = "Copy Download URLs";
myButton.id = "copy-download";
myButton.style.position = "fixed";
myButton.style.bottom = "10px";
myButton.style.right = "10px";

myButton.addEventListener("click", function () {
  const elements = Array.from(
    document.querySelectorAll(
      ".download-format-tmp > a, .download-format-tmp > .download-title > a",
    ),
  );

  const urls = elements
    .filter((el) => el.hasAttribute("data-bind") && el.hasAttribute("style"))
    .join("\n");

  console.log(urls);
  try {
    navigator.clipboard.writeText(urls);
    console.log('Text copied to clipboard');
  } catch (err) {
    console.error('Failed to copy: ', err);
  }
});

document.body.appendChild(myButton);
