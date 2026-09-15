// Register Stimulus controllers through the import map (digested asset-safe).
// `bin/rails stimulus:manifest:update` rewrites this file with relative `./` imports,
// which break under Propshaft (browser resolves /assets/controllers/application → 404).
// Add new `*_controller.js` files under this folder; importmap `pin_all_from` exposes them.

import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
