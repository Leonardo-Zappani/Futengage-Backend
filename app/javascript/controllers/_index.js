// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"
import Dropdown from "stimulus-dropdown"
import TextareaAutogrow from 'stimulus-textarea-autogrow'
import Notification from "stimulus-notification"

import controllers from "./**/*_controller.js"
controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})


// Eager load all controllers defined in the import map under controllers/**/*_controller
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

application.register('dropdown', Dropdown)
application.register('textarea-autogrow', TextareaAutogrow)
application.register('notification', Notification)
