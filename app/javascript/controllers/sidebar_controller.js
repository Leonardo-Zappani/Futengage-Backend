import { Controller } from "@hotwired/stimulus"
import { enter, leave } from 'el-transition'

export default class extends Controller {
    static targets = ["overlay", "menu"]

    connect() {
    }

    close() {
        Promise.all([leave(this.overlayTarget), leave(this.menuTarget)])
    }

    open() {
        Promise.all([enter(this.overlayTarget), enter(this.menuTarget)])
    }

    toggle() {
        Promise.all([toggle(this.overlayTarget), toggle(this.menuTarget)])
    }
}
