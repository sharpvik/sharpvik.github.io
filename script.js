/* 
 * clipboard.js framework (https://clipboardjs.com)
 * Initialize for button #cp.
 */
new ClipboardJS('#cp').on('success', function(e) { e.clearSelection(); });

/* Ensure that input's value is always #ffffff on page (re)load. */
document.getElementById('hex').value = '#ffffff';

/* Set background-color of #demo and input's value to a random color when
   #demo is clicked. */
document.addEventListener('click', function(e) {
    if ( !e.target.matches('#demo') ) return;
    let colour = randomHex();
    document.getElementById('hex').value = colour;
    document.getElementById('demo').style.background = colour;
});

/* Return a random hex colour string. */
function randomHex() {
    let hexOut = '#';
    for (let i = 0; i < 6; i++)
        hexOut += Math.floor(Math.random() * 15).toString(16);
    return hexOut;
}

/* Set background-color of #demo when user changes input's value. */
function setColor() {
    let colour = document.getElementById('hex').value;
    document.getElementById('demo').style.background = colour;
}

