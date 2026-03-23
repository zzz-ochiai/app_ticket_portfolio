console.log("ticket_toggle.js loaded")

document.addEventListener("turbo:load", () => {
  console.log("turbo:load fired")

  const buttons = document.querySelectorAll(".ticket-button")
  console.log("buttons:", buttons.length)

  buttons.forEach((button) => {
    button.addEventListener("click", () => {
      const used = button.dataset.used === "true"

      if (used) {
        button.textContent = "未使用"
        button.dataset.used = "false"
      } else {
        button.textContent = "使用済み"
        button.dataset.used = "true"
      }
    })
  })
})