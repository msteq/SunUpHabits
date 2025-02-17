import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"
import ConfirmController from "./confirm_controller"
import ProfileImagePreviewController from "./profile_image_preview_controller"

const application = Application.start()
application.register("hello", HelloController)
application.register("confirm", ConfirmController)
application.register("profile-image-preview", ProfileImagePreviewController)

export { application }