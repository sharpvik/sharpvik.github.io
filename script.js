document.addEventListener('click', function(e) {
    if (
        e.target.matches('input') ||
        e.target.matches('label') ||
        e.target.matches('section')
    ) return;
    let colour = randomHex();
    document.getElementById('hex').value = colour;
    document.body.style.background = colour;
});

function randomHex() {
    let hexOut = '#';
    for (let i = 0; i < 6; i++)
        hexOut += Math.floor(Math.random() * 15).toString(16);
    return hexOut;
}

function setColor() {
    let color = document.getElementById('hex').value;
    document.body.style.background = color;
}

(function() {
    document.getElementById('hex').value = '#ffffff';
})();
