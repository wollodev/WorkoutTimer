import AVFoundation

final class BackgroundAudioManager {
    private var audioPlayer: AVAudioPlayer?

    func activate() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)

            guard let url = Bundle.main.url(forResource: "silence", withExtension: "wav") else {
                return
            }

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0
            audioPlayer?.play()
        } catch {
            print("BackgroundAudioManager: \(error)")
        }
    }

    func deactivate() {
        audioPlayer?.stop()
        audioPlayer = nil

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
