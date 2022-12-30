import { Controller } from "@hotwired/stimulus"
import 'jquery-mask-plugin'

export default class extends Controller {
  maskBehavior(val) {
    return val.replace(/\D/g, '').length <= 11 ? '000.000.000-00999' : '00.000.000/0000-00';
  }

  onKeyPress(val, e, field, options){
    field.mask(this.maskBehavior.apply({}, arguments), options);
  }

  connect() {
    $(this.element).mask(this.maskBehavior.bind(this), {
      onKeyPress: this.onKeyPress.bind(this)
    })
  }

}
