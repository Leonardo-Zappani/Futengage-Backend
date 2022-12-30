import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'
import { post } from '@rails/request.js'

export default class extends Controller {
  static values = {
    allowDeselect: { type: Boolean, default: false },
    placeholder: { type: String, default: '' },
    url: { type: String, default: '' },
  }

  async connect() {
    this.select = new SlimSelect({
      select: this.element,
      allowDeselectOption: this.allowDeselectValue,
      placeholder: this.placeholderValue,
      addable: (v) => {
        Promise.resolve(this.addable.bind(this)(v))
        return false
      }
    })
  }

  async addable(value) {
    const response = await post(this.urlValue, {
      body: {
        contact: {
          name: value
        }
      },
      responseKind: 'json'
    })

    if (!response.ok) return false

    const contact = await response.json
    this.select.addData({ text: contact.name, value: `${contact.id}` })
    this.select.set(`${contact.id}`)
  }

  disconnect() {
    this.select.destroy()
  }
}
