import { Controller } from "@hotwired/stimulus"
import AirDatepicker from 'air-datepicker';
import localePtBR from 'air-datepicker/locale/pt-BR';
import localeEn from 'air-datepicker/locale/en';
import { createPopper } from '@popperjs/core';
import moment from 'moment';
import { get } from '@rails/request.js'
import { Turbo } from '@hotwired/turbo-rails';

export default class extends Controller {
  static values = {
    locale: { type: String, default: 'pt-BR' },
    viewFormat: { type: String, default: 'MMM/yyyy' },
    dateFormat: { type: String, default: 'YYYY-MM-DD' },
    formattedDate: String,
    bankAccount: String,
    transactionType: String,
    url: String
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

  disconnect() {
    this.datePicker.destroy()
  }

  connect() {
    const locale = this.locale()
    const dateFormat = this.dateFormatValue
    const viewFormat = this.viewFormatValue
    const formattedDate = this.formattedDateValue
    const url = this.urlValue
    const date = moment(formattedDate, dateFormat.toUpperCase(), this.localeValue.toLowerCase()).toDate()

    this.datePicker = new AirDatepicker(this.element, {
      locale: locale,
      dateFormat: viewFormat,
      showEvent: 'click',
      autoClose: false,
      selectedDates: [date],
      view: 'months',
      minView: 'months',
      container: window.document.body,
      onSelect: async ({date, formattedDate, datepicker}) => {
        let path = url.split('?')[0]
        window.Turbo.visit(`${path}?month=${moment(date).format(dateFormat)}&bank_account_id=${this.bankAccountValue}&transaction_type=${this.transactionTypeValue}`, { action: 'advance', frame: 'transactions_index' })
      },
      onShow: (isFinished) => {
        this.datePicker.setViewDate(date)
      },
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
    })
  }
}
