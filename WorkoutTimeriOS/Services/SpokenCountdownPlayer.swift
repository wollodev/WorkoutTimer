import AVFoundation

final class SpokenCountdownPlayer: Sendable {
    private nonisolated(unsafe) let synthesizer: AVSpeechSynthesizer
    private let queue = DispatchQueue(label: "speech", qos: .userInitiated)

    init() {
        let synth = AVSpeechSynthesizer()
        synth.usesApplicationAudioSession = true
        synthesizer = synth

        // Warm up the speech engine on a background thread at init
        // so the first real utterance doesn't cause a delay
        queue.async {
            let utterance = AVSpeechUtterance(string: " ")
            utterance.volume = 0
            utterance.preUtteranceDelay = 0
            utterance.postUtteranceDelay = 0
            synth.speak(utterance)
        }
    }

    func speak(_ text: String) {
        queue.async { [self] in
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.rate = AVSpeechUtteranceMaximumSpeechRate * 0.5
            utterance.volume = 1.0
            utterance.preUtteranceDelay = 0
            utterance.postUtteranceDelay = 0
            synthesizer.speak(utterance)
        }
    }

    func speakCountdown(_ number: Int) {
        let word: String
        switch number {
        case 3: word = String(localized: "spokenThree")
        case 2: word = String(localized: "spokenTwo")
        case 1: word = String(localized: "spokenOne")
        default: word = "\(number)"
        }
        speak(word)
    }

    func speakDone() {
        speak(String(localized: "spokenDone"))
    }
}
