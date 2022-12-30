import { Controller } from "@hotwired/stimulus"
import AirDatepicker from 'air-datepicker';
import localePtBR from 'air-datepicker/locale/pt-BR';
import localeEn from 'air-datepicker/locale/en';
import {createPopper} from '@popperjs/core';
import moment from 'moment';

export default class extends Controller {
  static values = {
    locale: {type: String, default: 'pt-BR'},
    format: {type: String, default: 'dd/MM/yyyy'}
  }

  locale() {
    switch (this.localeValue) {
      case 'pt-BR':
        return localePtBR
      case 'en':
        return localeEn
      default:
        return localePtBR
    }
  }

  connect() {
    this.options = this.options.bind(this)
    this.datePicker = new AirDatepicker(this.element, this.options())

    if (!!this.element.value) {
      this.datePicker.selectDate(moment(this.element.value, this.formatValue.toUpperCase(), this.localeValue.toLowerCase()).toDate(), { silent: true })
    }
  }

  options() {
    this.locale = this.locale.bind(this)

    return {
      locale: this.locale(),
      dateFormat: this.formatValue,
      autoClose: false,
      view: 'days',
      position({$datepicker, $target, $pointer, done}) {
        let popper = createPopper($target, $datepicker, {
          placement: 'top',
          modifiers: [
            {
              name: 'flip',
              options: {
                padding: {
                  top: 64
                }
              }
            },
            {
              name: 'offset',
              options: {
                offset: [0, 20]
              }
            },
            {
              name: 'arrow',
              options: {
                element: $pointer
              }
            }
          ]
        })

        return function completeHide() {
          popper.destroy();
          done();
        }
      }
    }
  }

  update(event) {
    if (this.element.value.length === this.formatValue.length) {
      this.datePicker.selectDate(moment(this.element.value, this.formatValue.toUpperCase(), this.localeValue.toLowerCase()).toDate(), { silent: true })
    }
  }
}
