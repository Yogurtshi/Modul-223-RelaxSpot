import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count", "action"]
  static values = {
    url: String,
    checkInUrl: String,
    authenticated: Boolean
  }

  connect() {
    this.refresh()
    this.interval = setInterval(() => this.refresh(), 5000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  async refresh() {
    try {
      const response = await fetch(this.urlValue, {
        headers: { Accept: "application/json" },
        credentials: "same-origin"
      })

      if (!response.ok) return

      const availability = await response.json()
      this.countTarget.textContent = `${availability.active_count}/${availability.capacity} people`

      if (this.authenticatedValue) {
        this.renderCheckInAction(availability.active_count >= availability.capacity)
      }
    } catch (error) {
      // Keep the current state when the availability request fails.
    }
  }

  renderCheckInAction(full) {
    const currentAction = this.actionTarget.querySelector(".action-button")

    if (full && currentAction?.tagName !== "SPAN") {
      currentAction.replaceWith(this.disabledAction())
    } else if (!full && currentAction?.tagName !== "A") {
      currentAction.replaceWith(this.checkInLink())
    }
  }

  disabledAction() {
    const element = document.createElement("span")
    element.className = "action-button action-button--disabled"
    element.setAttribute("aria-disabled", "true")
    element.textContent = "Place is full"
    return element
  }

  checkInLink() {
    const element = document.createElement("a")
    element.className = "action-button"
    element.href = this.checkInUrlValue
    element.textContent = "Check in here"
    return element
  }
}