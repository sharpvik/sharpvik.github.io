document.onkeydown = e => {
    if (!e.altKey && !e.ctrlKey) e.preventDefault()
}
const app = Elm.Main.init({
    node: document.getElementById("app")
})
app.ports.scroll.subscribe(e =>
    setTimeout(() => {
        const area = document.querySelector(".vsh-textarea")
        area.scrollTop = area.scrollHeight
    }, 50)
)
