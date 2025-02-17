import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput", "preview"];

  previewImage() {
    const file = this.fileInputTarget.files[0];
    if (file) {
      const imageUrl = URL.createObjectURL(file);
      this.previewTarget.src = imageUrl;
    }
  }
}