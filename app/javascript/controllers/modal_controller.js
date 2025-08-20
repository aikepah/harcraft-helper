import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["dialog", "componentId"]

  connect() {
  // ...
  }

  open(event) {
  // ...
    event.preventDefault()
    const componentId = event.currentTarget.dataset.modalComponentIdValue
    // Always find the hidden input inside the modal dialog
    const dialog = this.element.querySelector('[data-modal-target="dialog"]');
    const input = dialog ? dialog.querySelector('input[name="party_component[component_id]"]') : null;
    if (componentId && input) {
      input.value = componentId;
  // ...
    }
    if (dialog) {
      dialog.classList.remove("hidden")
      dialog.setAttribute("aria-modal", "true")
      dialog.focus()
  // ...
    }
  }

  close(event) {
  // ...
    if (event) event.preventDefault()
    this.dialogTarget.classList.add("hidden")
    this.dialogTarget.removeAttribute("aria-modal")
  // ...
  }
}
