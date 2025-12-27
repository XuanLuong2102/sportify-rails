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
