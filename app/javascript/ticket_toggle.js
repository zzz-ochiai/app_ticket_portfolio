console.log("ticket_toggle.js loaded")

// (1)HTMLを読み取り、ボタンの情報を取得して、各ボタンに対して変数を作成
document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".ticket-button")
  // htmlのクラス名がticket-buttonの要素を全て取得している。これにより、複数のチケットがある場合でも、全てのチケットに対して同じ処理を行うことができる。
  // documentでは、html全体を表すが、その後のクラス名などのセレクタを使用することで、特定の要素を選択している。

  buttons.forEach((button) => {
    const status = button.previousElementSibling
    // buttonのすぐ前の要素をただ取り出すだけ。ここでは、チケットの状態を表示する要素を取得している。
    const ticketId = button.dataset.ticketId
    // .〇〇はすべてメソッドではない。datasetは、data-〇〇という属性を持つ要素から、その属性の値を取得するためのプロパティである。ここでは、data-ticket-idという属性から、その値を取得している。
    
    // 保存されている表示状態を復元
    const pending = localStorage.getItem(`pending-ticket-${ticketId}`)
    const serverTime = button.dataset.updatedAt

    if (pending) {
      const pendingData = JSON.parse(pending)
      
      if (pendingData.updated_at > serverTime) {
        // Localのほうが新しい　⇒　反映
        updateDisplay(status, button, pendingData.used)
      } else {
        // サーバーのほうが新しい　⇒　Local削除
        localStorage.removeItem(`pending-ticket-${ticketId}`)
      }
    }

    // 未送信データがあれば再送を試す
    // リロード時にオンライン復帰している可能性があるため、ここで未送信のチェック。
    retryPending(ticketId)


// (2) ボタンがクリックされたときの処理⇒状態切替、LocalStrageへの保存、DBへの送信
    button.addEventListener("click", () => {
      console.log("button clicked:")

      // 操作した時刻を生成
      const updatedAt = new Date().toISOString()

      // 現在の使用状態を取得,使用済みであればtrue
       const currentUsed = button.dataset.used === "true"
       // 未使用から使用済みのみを許可
       console.log("currentUsed:", currentUsed)
       if (!currentUsed) {
        const newUsed = true
       
       // 画面切り替え
      updateDisplay(status, button, newUsed)

       // LocalStrageに現在状態を保存
      localStorage.setItem(`ticket-${ticketId}`, String(newUsed))

      // DB送信用のpendingも保存⇒送信用の一時的なキュー
      localStorage.setItem(`pending-ticket-${ticketId}`, JSON.stringify({
        used: newUsed,
        updated_at: updatedAt
      }))

      // オンラインの場合はサーバーに送信
      if (navigator.onLine) {
        sendTicketUpdate(ticketId, newUsed, updatedAt)
      }
    }
  })
})

// (3) オンライン復帰時に再送
  window.addEventListener("online", () => {
    // 画面上のすべてのボタンを取得
    const buttons = document.querySelectorAll(".ticket-button")
    
    buttons.forEach((button) => {
       const ticketId = button.dataset.ticketId

       // オンライン復帰時に未送信のデータがあれば再送
        retryPending(ticketId)
    })
  })
})

function updateDisplay(status, button, used) {
  if (used) {
    status.textContent = "使用済み"
    button.style.display = "none"
    button.dataset.used = "true"
  } else {
    status.textContent = "未使用"
    button.textContent = "使用済みにする"
    button.style.display = "inline-block"
    button.dataset.used = "false"
  }
}

function sendTicketUpdate(ticketId, used, updatedAt) {
  fetch(`/tickets/${ticketId}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      "Accept": "application/json"
    },
    body: JSON.stringify({ 
      ticket: { used: used },
      updated_at: updatedAt
    })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error("DB更新に失敗しました")
    }
    return response.json()
  })
  .then(data => {
    console.log("DB更新成功:", data)

    // 送信成功したらpendingを削除
    localStorage.removeItem(`pending-ticket-${ticketId}`)
  })

  // エラーが発生した場合は、pendingを残しておく（再送のため）
  .catch(error => {
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
