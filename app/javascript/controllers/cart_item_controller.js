import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]

  increase(event) {
    const variantId = event.currentTarget.dataset.variantId
    const currentQty = parseInt(this.quantityTarget.value)

    this.updateQuantity(variantId, currentQty + 1)
  }

  decrease(event) {
    const variantId = event.currentTarget.dataset.variantId
    const currentQty = parseInt(this.quantityTarget.value)

    if (currentQty > 1) {
      this.updateQuantity(variantId, currentQty - 1)
    }
  }

  async updateQuantity(variantId, quantity) {
    try {
      const response = await fetch(`/cart/update_item`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ variant_id: variantId, quantity: quantity })
      })

      if (response.ok) {
        window.location.reload()
      }
    } catch (error) {
      console.error('Error updating cart:', error)
    }
  }
}
