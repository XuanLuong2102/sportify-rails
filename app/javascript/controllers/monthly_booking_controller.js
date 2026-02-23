import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.placeSportId = document.querySelector('[name="booking[place_sport_id]"]')?.value
    this.pricePerHour = 0
    this.selectedDates = []
  }

  async updateDates(event) {
    const monthSelect = document.querySelector('[name="booking[month]"]')
    const yearSelect = document.querySelector('[name="booking[year]"]')
    const weekdayCheckboxes = document.querySelectorAll('[name="booking[weekdays][]"]:checked')
    
    if (!monthSelect || !yearSelect) return
    
    const month = parseInt(monthSelect.value)
    const year = parseInt(yearSelect.value)
    const selectedWeekdays = Array.from(weekdayCheckboxes).map(cb => parseInt(cb.value))
    
    // Calculate all dates for selected weekdays in the month
    this.selectedDates = this.getDatesForWeekdays(year, month, selectedWeekdays)
    
    // Update UI
    this.updateDatesList()
    this.updatePrice()
  }

  getDatesForWeekdays(year, month, weekdays) {
    const dates = []
    const firstDay = new Date(year, month - 1, 1)
    const lastDay = new Date(year, month, 0)
    
    for (let date = new Date(firstDay); date <= lastDay; date.setDate(date.getDate() + 1)) {
      if (weekdays.includes(date.getDay())) {
        dates.push(new Date(date))
      }
    }
    
    return dates
  }

  updateDatesList() {
    const datesList = document.getElementById('dates-list')
    const datesContainer = document.getElementById('selected-dates-container')
    
    if (!datesList) return
    
    datesList.innerHTML = ''
    datesContainer.innerHTML = ''
    
    if (this.selectedDates.length === 0) {
      document.getElementById('monthly-summary').style.display = 'none'
      return
    }
    
    // Show dates as badges
    this.selectedDates.forEach(date => {
      const badge = document.createElement('span')
      badge.className = 'badge bg-primary'
      badge.textContent = date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' })
      datesList.appendChild(badge)
      
      // Add hidden field for each date
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'booking[dates][]'
      input.value = date.toISOString().split('T')[0]
      datesContainer.appendChild(input)
    })
    
    document.getElementById('total-bookings').textContent = this.selectedDates.length
    document.getElementById('monthly-summary').style.display = 'block'
  }

  async updatePrice() {
    const startTimeSelect = document.querySelector('[name="booking[start_time]"]')
    const endTimeSelect = document.querySelector('[name="booking[end_time]"]')
    
    if (!startTimeSelect?.value || !endTimeSelect?.value || this.selectedDates.length === 0) {
      document.getElementById('submit-monthly-booking').disabled = true
      return
    }
    
    const startTime = startTimeSelect.value
    const endTime = endTimeSelect.value
    
    // Calculate hours
    const hours = this.calculateHours(startTime, endTime)
    
    try {
      const response = await fetch(
        `/calculate_price_bookings?place_sport_id=${this.placeSportId}&mode=monthly&dates=${this.selectedDates.length}&hours=${hours}`,
        { headers: { 'Accept': 'application/json' } }
      )
      
      if (response.ok) {
        const data = await response.json()
        
        document.getElementById('price-per-booking').textContent = 
          new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.price_per_booking)
        
        document.getElementById('total-price').textContent = 
          new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.total_price)
        
        document.getElementById('monthly-total-price').value = data.total_price
        document.getElementById('submit-monthly-booking').disabled = false
      }
    } catch (error) {
      console.error('Error calculating price:', error)
    }
    
    // Also add start_time and end_time to form
    const form = document.getElementById('monthly-booking-form')
    
    let startInput = form.querySelector('[name="booking[start_time]"]')
    if (!startInput) {
      startInput = document.createElement('input')
      startInput.type = 'hidden'
      startInput.name = 'booking[start_time]'
      form.appendChild(startInput)
    }
    startInput.value = startTime
    
    let endInput = form.querySelector('[name="booking[end_time]"]')
    if (!endInput) {
      endInput = document.createElement('input')
      endInput.type = 'hidden'
      endInput.name = 'booking[end_time]'
      form.appendChild(endInput)
    }
    endInput.value = endTime
  }

  calculateHours(startTime, endTime) {
    const [startHour, startMin] = startTime.split(':').map(Number)
    const [endHour, endMin] = endTime.split(':').map(Number)
    
    const start = startHour + startMin / 60
    const end = endHour + endMin / 60
    
    return Math.ceil(end - start)
  }
}
