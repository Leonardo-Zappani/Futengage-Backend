import Dropdown from 'stimulus-dropdown'

export default class extends Dropdown {
  connect() {
    super.connect()
  }

  toggle(event) {
    super.toggle()
    event.preventDefault()
    event.stopPropagation()
  }

  hide(event) {
    super.hide(event)
  }

  hideWithKeyboard(event) {
    if (event.code === "Escape") {
      this.leave(event)
    }
  }
}