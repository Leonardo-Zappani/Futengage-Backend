import { Controller } from '@hotwired/stimulus';
import SlimSelect from 'slim-select';
import { post } from '@rails/request.js';

export default class extends Controller {
  static values = {
    allowDeselect: { type: Boolean, default: true },
    placeholder: { type: String, default: 'Selecionar' },
  };

  connect() {
    this.select = new SlimSelect({
      select: this.element,
      settings: {
        hideSelected: true,
      },
      allowDeselectOption: this.allowDeselectValue,
      placeholder: this.placeholderValue,
      addable: (value) => this.addable(value),
    });
  }

  addable(value) {
    return {
      text: value,
      value: value.toLowerCase(),
    };
  }

  disconnect() {
    this.select.destroy();
  }
}
