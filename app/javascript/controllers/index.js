import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"
import ConfirmController from "./confirm_controller"

const application = Application.start()
application.register("hello", HelloController)
application.register("confirm", ConfirmController)

export { application }