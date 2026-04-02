console.log("ticket_toggle.js loaded")

document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".ticket-button")

  buttons.forEach((button) => {
    const status = button.previousElementSibling
    const ticketId = button.dataset.ticketId
    const saved = localStorage.getItem(`ticket-${ticketId}`)

    if (saved === "true") {
      status.textContent = "使用済み"
      button.textContent = "未使用に戻す"
      button.dataset.used = "true"
    } else if (saved === "false") {
      status.textContent = "未使用"
      button.textContent = "使用済みにする"
      button.dataset.used = "false"
    }

    button.addEventListener("click", () => {
      console.log("button clicked:")

      if (button.dataset.used === "false") {
        status.textContent = "使用済み"
        button.textContent = "未使用に戻す"
        button.dataset.used = "true"
        localStorage.setItem(`ticket-${ticketId}`, "true")
      } else {
        status.textContent = "未使用"
        button.textContent = "使用済みにする"
        button.dataset.used = "false"
        localStorage.setItem(`ticket-${ticketId}`, "false")
      }
    })
  })
})