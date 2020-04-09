/* Shortcut to "querySelector". */
function $(selector) { return document.querySelector(selector); }

/* 
 * clipboard.js framework (https://clipboardjs.com)
 * Initialize for button #cp.
 */
new ClipboardJS('#cp').on('success', function(e) { e.clearSelection(); });

/* Ensure that input's value is always #ffffff on page (re)load. */
$('#hex').value = '#ffffff';

/* The "rain" interval ids are to be held here. */
var itrains = null;

/* Boolean value to know whether topbar is hidden or not. */
var topbarHidden = false;

/* Set background-color of #demo and input's value to a random color. */
function changeColor() {
    let color = randomHex();
    $('#hex').value = color;
    $('#demo').style.background = color;
}

/* 
 * Toggle rain using "setInterval" and "clearInterval".
 * The "itrains" variable is set to null when rain is no longer so that it is
 * apparent whether it rains or not.
 */
function toggleRain() {
    let rain = $('#rain'),
        demo = $('#demo');

    if (itrains) {
        clearInterval(itrains);
        rain.innerHTML = 'Make It Rain!';
        itrains = null;
        demo.classList.remove('cursor-not-allowed');
    } else {
        itrains = setInterval(changeColor, 300);
        rain.innerHTML = 'Stop The Rain!';
        demo.classList.add('cursor-not-allowed');
    }
}

/* Return a random hex color string. */
function randomHex() {
    let hexOut = '#';
    for (let i = 0; i < 6; i++)
        hexOut += Math.floor(Math.random() * 15).toString(16);
    return hexOut;
}

/* Set background-color of #demo when user changes input's value. */
function setColor() {
    let color = $('#hex').value;
    $('#demo').style.background = color;
}

/* Show/hide topbar so that the color itself takes up the whole screen. */
function toggleTopbar() {
    let topbar = $('#topbar'),
        hider = $('#hider'),
        topbarHeight = topbar.clientHeight;

    topbar.style.top = (topbarHidden) ? '0px' : -topbarHeight + 'px';
    topbarHidden = !topbarHidden;

    hider.innerHTML = (topbarHidden) ? 'arrow_drop_down_circle' : 'cancel';
}

