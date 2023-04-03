import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"
export default class extends Controller {
    static targets = ["next_event"];
    connect() {
        console.log("hello there");


        this.secondsUntilEnd = this.next_eventTarget.dataset.secondsUntilEndValue;
        //console.log(this.secondsUntilEnd);

        const now = new Date().getTime();
        this.endTime = new Date(now + this.secondsUntilEnd * 1000);

        this.countdown = setInterval(this.countdown.bind(this), 250);




    }

    countdown() {
        const now = new Date();
        const secondsRemaining = (this.endTime - now) / 1000;

        if (secondsRemaining <= 0) {
            clearInterval(this.countdown);
            this.next_eventTarget.innerHTML = "Countdown is over!";
            return;
        }

        const secondsPerDay = 86400;
        const secondsPerHour = 3600;
        const secondsPerMinute = 60;

        const days = Math.floor(secondsRemaining / secondsPerDay);
        const hours = Math.floor(
            (secondsRemaining % secondsPerDay) / secondsPerHour
        );
        const minutes = Math.floor(
            (secondsRemaining % secondsPerHour) / secondsPerMinute
        );
        const seconds = Math.floor(secondsRemaining % secondsPerMinute);

        this.next_eventTarget.innerHTML = `${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds`;
    }
}