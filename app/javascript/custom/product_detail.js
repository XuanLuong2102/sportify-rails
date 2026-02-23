const initProductDetail = () => {
    const variantsDataEl = document.getElementById('variants-data');
    if (!variantsDataEl) return;

    // console.log('Init Product Detail JS');

    const variants = JSON.parse(variantsDataEl.dataset.variants || '[]');
    const colorDataEl = document.getElementById('color-data');
    let colorData = [];
    if (colorDataEl) {
        try { colorData = JSON.parse(colorDataEl.textContent); } catch (e) { }
    }

    const els = {
        mainImage: document.getElementById('main-image'),
        price: document.getElementById('product-price'),
        variantInput: document.getElementById('variant-id-input'),
        colorSelect: document.getElementById('color-select'),
        colorPreview: document.getElementById('color-preview'),
        sizeSelect: document.getElementById('size-select'),
        sizeContainer: document.getElementById('size-container'),
        qtyMinus: document.getElementById('qty-minus'),
        qtyPlus: document.getElementById('qty-plus'),
        quantityInput: document.getElementById('quantity-input'),
        submitBtn: document.getElementById('add-to-cart-btn'),
        thumbs: document.querySelectorAll('.image-thumb'),
        placeSelect: document.getElementById('place-select'),
        addToCartForm: document.getElementById('add-to-cart-form')
    };

    // Form submission validation
    if (els.addToCartForm) {
        els.addToCartForm.addEventListener('submit', function (e) {
            const currentCartPlaceId = this.dataset.currentCartPlaceId;
            // The selected place_id can be from a hidden field or a select
            const selectedPlaceIdEl = this.querySelector('[name="place_id"]');
            const selectedPlaceId = selectedPlaceIdEl ? selectedPlaceIdEl.value : null;

            if (currentCartPlaceId && selectedPlaceId && currentCartPlaceId !== selectedPlaceId) {
                e.preventDefault();
                alert('Bạn không thể thêm sản phẩm từ địa điểm khác vào cùng một đơn hàng. Vui lòng thanh toán hoặc xóa giỏ hàng hiện tại trước khi đặt từ địa điểm này.');
            }
        });
    }

    // State
    let state = {
        colorId: null,
        sizeId: null
    };

    // Event Listeners
    if (els.thumbs) {
        els.thumbs.forEach(thumb => {
            thumb.addEventListener('click', function () {
                if (els.mainImage) els.mainImage.src = this.dataset.src;
                els.thumbs.forEach(t => t.classList.remove('border-primary'));
                this.classList.add('border-primary');
            });
        });
    }

    if (els.colorSelect) {
        els.colorSelect.addEventListener('change', function () {
            const colorId = parseInt(this.value);
            state.colorId = colorId;

            // Update preview
            if (els.colorPreview && colorData.length) {
                const color = colorData.find(c => c.id === colorId);
                els.colorPreview.style.backgroundColor = color ? color.code : '#eee';
            }

            updateSizes(colorId);
            updateState();
        });
    }

    if (els.sizeSelect) {
        els.sizeSelect.addEventListener('change', function () {
            state.sizeId = parseInt(this.value);
            updateState();
        });
    }

    if (els.placeSelect) {
        els.placeSelect.addEventListener('change', function () {
            updateState();
        });
    }

    if (els.qtyMinus) {
        els.qtyMinus.addEventListener('click', function () {
            let val = parseInt(els.quantityInput.value) || 1;
            if (val > 1) els.quantityInput.value = val - 1;
        });
    }

    if (els.qtyPlus) {
        els.qtyPlus.addEventListener('click', function () {
            let val = parseInt(els.quantityInput.value) || 1;
            els.quantityInput.value = val + 1;
        });
    }

    function updateSizes(colorId) {
        if (!els.sizeSelect) return;

        const availableSizes = variants.filter(v => v.color_id === colorId);

        Array.from(els.sizeSelect.options).forEach(opt => {
            const sizeId = parseInt(opt.value);
            if (isNaN(sizeId)) return;

            const variant = availableSizes.find(v => v.size_id === sizeId);

            if (variant) {
                opt.disabled = false;
                opt.text = variant.size_name + (variant.stock <= 0 ? ' (Out of stock)' : '');
                if (variant.stock <= 0) opt.disabled = true;
            } else {
                opt.disabled = true;
                opt.text = opt.getAttribute('data-original-text') + ' (Unavailable)';
            }
        });

        // Reset size if invalid
        const currentSizeId = parseInt(els.sizeSelect.value);
        if (currentSizeId) {
            const isValid = availableSizes.some(v => v.size_id === currentSizeId && v.stock > 0);
            if (!isValid) {
                els.sizeSelect.value = "";
                state.sizeId = null;
            }
        }
    }

    function updateState() {
        const isPlaceSelected = !els.placeSelect || els.placeSelect.value !== "";

        if (!state.colorId || !state.sizeId || !isPlaceSelected) {
            if (els.submitBtn) els.submitBtn.disabled = true;
            return;
        }

        const variant = variants.find(v => v.color_id === state.colorId && v.size_id === state.sizeId);

        if (variant) {
            if (els.price) {
                els.price.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(variant.price);
            }
            if (els.variantInput) {
                els.variantInput.value = variant.id;
            }

            if (els.submitBtn) {
                els.submitBtn.disabled = variant.stock <= 0;
                if (variant.stock <= 0) {
                    els.submitBtn.innerHTML = 'Out of Stock';
                } else {
                    els.submitBtn.innerHTML = '<i class="bi bi-cart-plus"></i> Add to Cart';
                }
            }
        }
    }
};

// Run on Turbo load and DOM ready
document.addEventListener('turbo:load', initProductDetail);
document.addEventListener('DOMContentLoaded', initProductDetail);
