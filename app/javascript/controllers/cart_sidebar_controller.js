import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  toggle() {
    this.sidebarTarget.classList.toggle("open")
    this.overlayTarget.classList.toggle("show")
  }

  close() {
    this.sidebarTarget.classList.remove("open")
    this.overlayTarget.classList.remove("show")
  }

  open() {
    this.sidebarTarget.classList.add("open")
    this.overlayTarget.classList.add("show")
  }
}
