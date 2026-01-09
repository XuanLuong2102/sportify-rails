// Admin Products JavaScript

/**
 * Initialize product-related functionality
 */
export function initializeProducts() {
  initializeTooltips();
  initializeNestedForms();
  initializeImagePreview();
  initializeProductCreation();
}

/**
 * Initialize image preview for file inputs
 * Works for both thumbnail and gallery images
 */
function initializeImagePreview() {
  document.addEventListener('change', function(e) {
    const input = e.target;
    // Check if this is a file input
    if (input.type === 'file' && input.files && input.files[0]) {
      const reader = new FileReader();
      
      reader.onload = function(event) {
        // Find nearest img tag for preview
        // Works for both main thumbnail and gallery images
        let previewImg;
        const wrapper = input.closest('.nested-fields') || input.closest('.mb-3');
        
        if (wrapper) {
          previewImg = wrapper.querySelector('img');
          if (previewImg) {
            previewImg.src = event.target.result;
            previewImg.classList.remove('d-none'); // Show image if hidden
          }
        }
      };
      reader.readAsDataURL(input.files[0]);
    }
  });
}

/**
 * Initialize Bootstrap tooltips for product images
 */
function initializeTooltips() {
  const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  tooltipTriggerList.forEach(function(tooltipTriggerEl) {
    // Dispose existing tooltip if any
    const existingTooltip = bootstrap.Tooltip.getInstance(tooltipTriggerEl);
    if (existingTooltip) {
      existingTooltip.dispose();
    }
    // Create new tooltip
    new bootstrap.Tooltip(tooltipTriggerEl);
  });
}

/**
 * Initialize nested forms (Add/Remove fields for variants and images)
 * This handles dynamic form field addition and removal for:
 * - Product variants (size & color)
 * - Product images (gallery)
 */
function initializeNestedForms() {
  if (window.nestedFormHandlerSet) return;
  window.nestedFormHandlerSet = true;

  // Handle ADD button click
  document.addEventListener('click', function(e) {
    const addBtn = e.target.closest('.add_fields');
    if (addBtn) {
      e.preventDefault();
      const time = new Date().getTime();
      const regexp = new RegExp(addBtn.dataset.id, 'g');
      const content = addBtn.dataset.fields.replace(regexp, time);
      const buttonText = addBtn.textContent.toLowerCase();

      if (buttonText.includes('image')) {
        document.getElementById('product_images_container')?.insertAdjacentHTML(
          'beforeend',
          content
        );
      } else {
        document.getElementById('product_variants')?.insertAdjacentHTML(
          'beforeend',
          content
        );
      }
    }
  });

  // Handle REMOVE button click
  document.addEventListener('click', function(e) {
    const removeBtn = e.target.closest('.remove_fields');
    if (removeBtn) {
      e.preventDefault();
      const wrapper = removeBtn.closest('.nested-fields');
      
      if (wrapper) {
        const destroyField = wrapper.querySelector('.destroy-field');
        if (destroyField) {
          destroyField.value = '1';
          wrapper.style.display = 'none';
        } else {
          wrapper.remove();
        }
      }
    }
  });
}

/**
 * Initialize product creation form
 * Handles:
 * - Auto-fill English name from Vietnamese name
 * - Color and size selection
 * - Combination summary
 */
function initializeProductCreation() {
  // Check if creation form elements exist
  const colorBtns = document.querySelectorAll('.color-btn');
  const sizeBtns = document.querySelectorAll('.size-btn');
  
  if (colorBtns.length === 0 || sizeBtns.length === 0) return;

  // Check if already initialized with flag
  if (window.productCreationInitialized) return;
  window.productCreationInitialized = true;

  let selectedColorIds = [];
  let selectedSizeIds = [];

  // Auto-fill name_en from name_vi
  const nameViInput = document.querySelector('input[name="product[name_vi]"]');
  const nameEnInput = document.querySelector('input[name="product[name_en]"]');
  
  if (nameViInput && nameEnInput) {
    nameViInput.addEventListener('change', function() {
      if (!nameEnInput.value) {
        nameEnInput.value = this.value;
      }
    });
  }

  const selectedColorsInput = document.getElementById('selected_colors');
  const selectedSizesInput = document.getElementById('selected_sizes');
  const selectionSummary = document.getElementById('selection-summary');

  // Exit if required elements don't exist
  if (!selectedColorsInput || !selectedSizesInput || !selectionSummary) return;

  // Handle color selection
  colorBtns.forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      const colorId = this.dataset.colorId;
      const index = selectedColorIds.indexOf(colorId);
      
      if (index > -1) {
        selectedColorIds.splice(index, 1);
        this.classList.remove('active');
      } else {
        selectedColorIds.push(colorId);
        this.classList.add('active');
      }
      
      updateSelections();
    });
  });

  // Handle size selection
  sizeBtns.forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      const sizeId = this.dataset.sizeId;
      const index = selectedSizeIds.indexOf(sizeId);
      
      if (index > -1) {
        selectedSizeIds.splice(index, 1);
        this.classList.remove('active');
      } else {
        selectedSizeIds.push(sizeId);
        this.classList.add('active');
      }
      
      updateSelections();
    });
  });

  function updateSelections() {
    // Update hidden inputs
    selectedColorsInput.value = selectedColorIds.join(',');
    selectedSizesInput.value = selectedSizeIds.join(',');

    // Get color and size names
    const selectedColorNames = Array.from(colorBtns)
      .filter(btn => selectedColorIds.includes(btn.dataset.colorId))
      .map(btn => btn.dataset.colorName);
    
    const selectedSizeNames = Array.from(sizeBtns)
      .filter(btn => selectedSizeIds.includes(btn.dataset.sizeId))
      .map(btn => btn.dataset.sizeName);

    // Update summary
    updateSummary(selectedColorNames, selectedSizeNames);
  }

  function updateSummary(colors, sizes) {
    // If nothing selected, show "No selections yet"
    if (colors.length === 0 && sizes.length === 0) {
      selectionSummary.innerHTML = '<small class="text-muted">No selections yet</small>';
      return;
    }

    // If only colors selected (no sizes)
    if (colors.length > 0 && sizes.length === 0) {
      const html = `
        <small>
          <strong>Selected colors: ${colors.length}</strong><br>
          ${colors.map(c => `<span class="badge bg-info me-2">${c}</span>`).join('')}
        </small>
      `;
      selectionSummary.innerHTML = html;
      return;
    }

    // If only sizes selected (no colors)
    if (sizes.length > 0 && colors.length === 0) {
      const html = `
        <small>
          <strong>Selected sizes: ${sizes.length}</strong><br>
          ${sizes.map(s => `<span class="badge bg-info me-2">${s}</span>`).join('')}
        </small>
      `;
      selectionSummary.innerHTML = html;
      return;
    }

    // If both colors and sizes selected, create combinations
    const combinations = [];
    colors.forEach(color => {
      sizes.forEach(size => {
        combinations.push(`${color} - ${size}`);
      });
    });

    const html = `
      <small>
        <strong>Total variants to create: ${combinations.length}</strong><br>
        ${combinations.map(c => `<span class="badge bg-info me-2">${c}</span>`).join('')}
      </small>
    `;
    selectionSummary.innerHTML = html;
  }
}

// Auto-initialize on turbo:load event
document.addEventListener('turbo:load', initializeProducts);

// Export for manual initialization if needed
export default {
  initializeProducts,
  initializeTooltips,
  initializeNestedForms,
  initializeProductCreation
};
