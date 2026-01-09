// Product Colors JavaScript Module
export function initializeProductColors() {
  const colorPickerInput = document.querySelector('input[type="color"][name="product_color[code_rgb]"]');
  const codeTextInput = document.querySelector('input[type="text"][name="product_color[code_rgb]"]');
  const preview = document.getElementById('color-preview');

  if (!colorPickerInput || !codeTextInput || !preview) return;

  // Function to update preview and sync inputs
  function updateColor(color) {
    // Validate and normalize color format
    let hexColor = color.trim();
    
    // If it's from color picker, it's already in #RRGGBB format
    if (colorPickerInput.value && color === colorPickerInput.value) {
      hexColor = color;
    } else {
      // If it's from text input, validate the format
      if (!/^#?[0-9A-F]{6}$/i.test(hexColor)) {
        return; // Invalid color, don't update
      }
      // Ensure it has # prefix
      if (!hexColor.startsWith('#')) {
        hexColor = '#' + hexColor;
      }
    }

    // Update both inputs
    colorPickerInput.value = hexColor;
    codeTextInput.value = hexColor;
    
    // Update preview
    preview.style.backgroundColor = hexColor;
  }

  // Listen to color picker change
  colorPickerInput.addEventListener('change', function(e) {
    updateColor(e.target.value);
  });

  // Listen to color picker input (real-time)
  colorPickerInput.addEventListener('input', function(e) {
    updateColor(e.target.value);
  });

  // Listen to text input change
  codeTextInput.addEventListener('input', function(e) {
    updateColor(e.target.value);
  });

  // Set initial color if exists
  const initialColor = colorPickerInput.value || codeTextInput.value || '#FFFFFF';
  if (initialColor) {
    updateColor(initialColor);
  }
}

// Auto-initialize on Turbo load
document.addEventListener('turbo:load', initializeProductColors);
