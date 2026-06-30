console.log("ticket_toggle.js loaded")

document.addEventListener("turbo:load", () => {
  const ticketCards = document.querySelectorAll(".ticket-card")

  ticketCards.forEach((ticketCard) => {
    const ticketId = ticketCard.dataset.ticketId
    const serverTime = ticketCard.dataset.updatedAt

    // 保存されている状態を復元
    const pending = localStorage.getItem(`pending-ticket-${ticketId}`)

    if (pending) {
      const pendingData = JSON.parse(pending)

      if (pendingData.updated_at > serverTime) {
        updateDisplay(ticketCard, pendingData.used)
      } else {
        localStorage.removeItem(`pending-ticket-${ticketId}`)
      }
    }

    // 未送信データがあれば再送
    retryPending(ticketId)

    // チケットクリック
    ticketCard.addEventListener("click", () => {
      console.log("ticket clicked")

      const currentUsed = ticketCard.classList.contains("used")
      if (currentUsed) return

      const updatedAt = new Date().toISOString()

      // 画面更新
      updateDisplay(ticketCard, true)

      // LocalStorage保存
      localStorage.setItem(`ticket-${ticketId}`, "true")

      // 再送用データ保存
      localStorage.setItem(
        `pending-ticket-${ticketId}`,
        JSON.stringify({
          used: true,
          updated_at: updatedAt
        })
      )

      // オンラインなら送信
      if (navigator.onLine) {
        sendTicketUpdate(ticketId, true, updatedAt)
      }
    })
  })

  // オンライン復帰時
  window.addEventListener("online", () => {
    const ticketCards = document.querySelectorAll(".ticket-card")

    ticketCards.forEach((ticketCard) => {
      retryPending(ticketCard.dataset.ticketId)
    })
  })
})

function updateDisplay(ticketCard, used) {
  if (used) {
    ticketCard.classList.add("used")
  } else {
    ticketCard.classList.remove("used")
  }
}

function sendTicketUpdate(ticketId, used, updatedAt) {
  fetch(`/tickets/${ticketId}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector(
        'meta[name="csrf-token"]'
      ).content,
      "Accept": "application/json"
    },
    body: JSON.stringify({
      ticket: { used: used },
      updated_at: updatedAt
    })
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("DB更新に失敗しました")
      }
      return response.json()
    })
    .then((data) => {
      console.log("DB更新成功:", data)

      localStorage.removeItem(`pending-ticket-${ticketId}`)
    })
    .catch((error) => {
      console.error("DB更新エラー:", error)
    })
}

function retryPending(ticketId) {
  const pending = localStorage.getItem(`pending-ticket-${ticketId}`)
  if (pending === null) return
  if (!navigator.onLine) return

  const pendingData = JSON.parse(pending)

  sendTicketUpdate(ticketId, pendingData.used, pendingData.updated_at)
}