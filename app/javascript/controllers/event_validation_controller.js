import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


// Connects to data-controller="event-validation"
export default class extends Controller {
  connect() {
    console.debug("It works!")
  }
  change(event) {    
    let date = document.getElementById("event_eventDate").value;
    let start = document.getElementById("event_timeIni").value ;
    let category = document.getElementById("select2_category").value;
    console.log("------------------- DATE ------------------")
    console.log(date);
    console.log("------------------- Start Time ------------------")
    console.log(start);
    console.log("------------------- CATEGORY ------------------")
    console.log(category);
    if ((date != "") && (start != "") &&(category != "")) {            
      get(`/events/event_validation?date=${date}&start=${start}&category=${category}`, {
        responseKind: "turbo-stream"        
      })
      console.log("After the get request");    
    }else{
      console.log("Some variable is missing");
    }
    
  }
}
