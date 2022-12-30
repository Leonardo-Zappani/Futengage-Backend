import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'
import { post } from '@rails/request.js'

export default class extends Controller {
  static values = {
    allowDeselect: { type: Boolean, default: false },
    placeholder: { type: String, default: '' }
  }

  async connect() {
    this.select = new SlimSelect({
      select: this.element,
      allowDeselectOption: this.allowDeselectValue,
      deselectLabel: '✖',
      placeholder: this.placeholderValue
    })
  }

  disconnect() {
    this.select.destroy()
  }
}
