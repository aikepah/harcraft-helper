
// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import ModalController from "controllers/modal_controller"
import ExpandableRowController from "controllers/expandable_row_controller"
eagerLoadControllersFrom("controllers", application)
application.register("modal", ModalController)
application.register("expandable-row", ExpandableRowController)
