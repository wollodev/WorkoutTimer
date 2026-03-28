import AVFoundation

final class AudioFeedbackPlayer {
    private var player: AVAudioPlayer?

    init() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = 1.0
        player?.prepareToPlay()
    }

    func playBeep() {
        player?.currentTime = 0
        player?.play()
    }
}
