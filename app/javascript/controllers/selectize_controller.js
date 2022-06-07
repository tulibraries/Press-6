import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entries", "pagination"]
  connect() {
    $("select").selectize({
      maxItems: 3,
    });
  }
}