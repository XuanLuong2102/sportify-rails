import { Controller } from "@hotwired/stimulus"

// Booking Schedule Controller for Weekly View
export default class extends Controller {
  static targets = ["cell"]
  
  connect() {
    this.selectedCell = null
    this.placeSportId = document.querySelector('[name="booking[place_sport_id]"]')?.value
  }

  selectSlot(event) {
    const cell = event.currentTarget
    
    // Check if cell is available
    if (cell.dataset.available === 'false') {
      return
    }
    
    // Deselect previous cell
    if (this.selectedCell) {
      this.selectedCell.classList.remove('selected')
    }
    
    // Select new cell
    cell.classList.add('selected')
    this.selectedCell = cell
    
    // Update form fields
    document.getElementById('selected-date').value = cell.dataset.date
    document.getElementById('selected-start-time').value = cell.dataset.start
    document.getElementById('selected-end-time').value = cell.dataset.end
    
    // Update summary
    this.updateSummary(cell.dataset.date, cell.dataset.start, cell.dataset.end)
    
    // Show summary and enable submit
    document.getElementById('booking-summary').style.display = 'block'
    document.getElementById('submit-booking').disabled = false
  }

  async updateSummary(date, startTime, endTime) {
    const dateObj = new Date(date)
    const dateFormatted = dateObj.toLocaleDateString('vi-VN', { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })
    
    document.getElementById('summary-date').textContent = dateFormatted
    document.getElementById('summary-time').textContent = `${startTime} - ${endTime}`
    
    // Calculate price
    try {
      const response = await fetch(
        `/calculate_price_bookings?place_sport_id=${this.placeSportId}&start_time=${startTime}&end_time=${endTime}`,
        { headers: { 'Accept': 'application/json' } }
      )
      
      if (response.ok) {
        const data = await response.json()
        document.getElementById('summary-price').textContent = data.price_vnd_formatted
        document.getElementById('selected-total-price').value = data.price_vnd
      }
    } catch (error) {
      console.error('Error calculating price:', error)
    }
  }
}

