// import "flowbite-datepicker";
// import "flowbite/dist/datepicker.turbo.js";

import { Application } from "@hotwired/stimulus";

const application = Application.start();


// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
