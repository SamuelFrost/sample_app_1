import { Controller } from "@hotwired/stimulus"

// Cycles through phrases with a typewriter effect on the hero tagline.
export default class extends Controller {
  static targets = ["text", "cursor"]
  static values = {
    phrases: { type: Array, default: [] },
    typingSpeed: { type: Number, default: 55 },
    pauseDuration: { type: Number, default: 2200 }
  }

  connect() {
    this.phraseIndex = 0
    this.charIndex = 0
    this.deleting = false
    this.tick()
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  tick() {
    const phrase = this.phrasesValue[this.phraseIndex % this.phrasesValue.length]

    if (this.deleting) {
      this.charIndex = Math.max(0, this.charIndex - 1)
    } else {
      this.charIndex = Math.min(phrase.length, this.charIndex + 1)
    }

    this.textTarget.textContent = phrase.slice(0, this.charIndex)

    let delay = this.deleting ? this.typingSpeedValue / 2 : this.typingSpeedValue

    if (!this.deleting && this.charIndex === phrase.length) {
      this.deleting = true
      delay = this.pauseDurationValue
    } else if (this.deleting && this.charIndex === 0) {
      this.deleting = false
      this.phraseIndex++
    }

    this.timer = setTimeout(() => this.tick(), delay)
  }
}
