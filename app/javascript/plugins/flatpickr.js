import flatpickr from "flatpickr"
import "flatpickr/dist/themes/material_red.css"// Note this is important!


import rangePlugin from "flatpickr/dist/plugins/rangePlugin"

flatpickr(".datepicker", {
  minDate: "today",
  enableTime: true
  mode: "multiple",
  dateFormat: "Y-m-d",

})
