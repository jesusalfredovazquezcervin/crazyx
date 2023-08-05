import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [ "source" ]
  connect() {
    //console.log("hello there");
  }
  copy(){
    //console.log("hello there");
    navigator.clipboard.writeText(this.sourceTarget.value);    
  }
}
