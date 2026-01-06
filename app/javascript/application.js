// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery

import "@hotwired/turbo-rails" 
import "bootstrap"

document.addEventListener("turbo:load", () => {
  const sidebarToggle = document.body.querySelector("#sidebarToggle");

  if (sidebarToggle) {
    sidebarToggle.addEventListener("click", (event) => {
      event.preventDefault();
      document.body.classList.toggle("sb-sidenav-toggled");
      localStorage.setItem(
        "sb|sidebar-toggle",
        document.body.classList.contains("sb-sidenav-toggled")
      );
    });
  }

  if (window.nestedFormHandlerSet) return;
  window.nestedFormHandlerSet = true;

  // 2. XỬ LÝ THÊM (ADD)
  document.addEventListener('click', function(e) {
    const addBtn = e.target.closest('.add_fields');
    if (addBtn) {
      e.preventDefault();
      const time = new Date().getTime();
      const regexp = new RegExp(addBtn.dataset.id, 'g');
      const content = addBtn.dataset.fields.replace(regexp, time);
      const buttonText = addBtn.textContent.toLowerCase();
      
      if (buttonText.includes('image')) {
        document.getElementById('product_images_container').insertAdjacentHTML('beforeend', content);
      } else {
        document.getElementById('product_variants').insertAdjacentHTML('beforeend', content);
      }
    }
  });

  // 3. XỬ LÝ XÓA (REMOVE)
  document.addEventListener('click', function(e) {
    const removeBtn = e.target.closest('.remove_fields');
    if (removeBtn) {
      e.preventDefault();
      const wrapper = removeBtn.closest('.nested-fields');
      const destroyField = wrapper.querySelector('.destroy-field');
      if (destroyField) {
        destroyField.value = '1';
        wrapper.style.display = 'none';
      } else {
        wrapper.remove();
      }
    }
  });

  // 4. XỬ LÝ PREVIEW ẢNH (Dùng cho cả Thumbnail và Gallery)
  document.addEventListener('change', function(e) {
    const input = e.target;
    // Kiểm tra xem đây có phải là input file không
    if (input.type === 'file' && input.files && input.files[0]) {
      const reader = new FileReader();
      
      reader.onload = function(event) {
        // Tìm thẻ img gần nhất để hiển thị preview
        // Cách này hoạt động cho cả Thumbnail chính và các ảnh Gallery
        let previewImg;
        const wrapper = input.closest('.nested-fields') || input.closest('.mb-3');
        
        if (wrapper) {
          previewImg = wrapper.querySelector('img');
          if (previewImg) {
            previewImg.src = event.target.result;
            previewImg.classList.remove('d-none'); // Hiện ảnh nếu đang ẩn
          }
        }
      };
      reader.readAsDataURL(input.files[0]);
    }
  });
});

document.addEventListener("turbo:load", initSwiper);
document.addEventListener("DOMContentLoaded", initSwiper);

function initSwiper() {
  if (typeof Swiper === 'undefined') return;

  const swiperEl = document.querySelector(".mySwiper");
  if (!swiperEl) return;

  const swiper = new Swiper(swiperEl, {
    loop: true,
    centeredSlides: true,
    slidesPerView: "auto",
    spaceBetween: 12,
    autoplay: {
      delay: 5000,
      disableOnInteraction: false,
    },
    speed: 700,
    pagination: {
      el: ".swiper-pagination",
      clickable: true,
    },
  });

  let isTransitioning = false;

  // Swiper event hooks
  swiper.on('slideChangeTransitionStart', () => {
    isTransitioning = true;
  });
  swiper.on('slideChangeTransitionEnd', () => {
    isTransitioning = false;
  });

  // Click listener
  swiperEl.addEventListener("click", function (e) {
    // Nếu đang chuyển slide thì không cho click
    if (isTransitioning || swiper.animating) return;

    const rect = swiperEl.getBoundingClientRect();
    const clickX = e.clientX - rect.left;
    const halfWidth = rect.width / 2;

    if (clickX < halfWidth) {
      swiper.slidePrev();
    } else {
      swiper.slideNext();
    }
  });
}
