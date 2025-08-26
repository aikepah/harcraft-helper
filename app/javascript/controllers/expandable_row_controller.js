import { Controller } from "@hotwired/stimulus"

// Stimulus controller for expanding/collapsing component rows
export default class extends Controller {
  static values = { componentId: Number }

  static targets = ["icon"];

  toggle(event) {
    const btn = event.currentTarget;
    const rowId = `craftable-items-${this.componentIdValue}`;
    const row = document.getElementById(rowId);
    if (row.classList.contains("hidden")) {
      row.classList.remove("hidden");
      if (this.hasIconTarget) {
        this.iconTarget.innerHTML = "&#9660;"; // Down arrow
      }
      btn.setAttribute("aria-expanded", "true");
    } else {
      row.classList.add("hidden");
      if (this.hasIconTarget) {
        this.iconTarget.innerHTML = "&#9654;"; // Right arrow
      }
      btn.setAttribute("aria-expanded", "false");
    }
  }
}
