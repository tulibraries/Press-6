import flatpickr from 'flatpickr'

function bindDateTimePickers() {
  [...document.querySelectorAll('[data-type="time"]')].forEach((time) => {
    flatpickr(time, {
      enableTime: true,
      enableSeconds: true,
      noCalendar: true,
      altInput: true,
      altFormat: ' h:i:S K',
      dateFormat: 'H:i'
    })
  });

  [...document.querySelectorAll('[data-type="datetime"]')].forEach((time) => {
    flatpickr(time, {
      enableTime: true,
      altInput: true,
      altFormat: 'F J (D), Y - h:i K',
      dateFormat: 'Y-m-d H:i'
    })
  });
}

document.addEventListener("turbolinks:load", function () {
  bindDateTimePickers();
})