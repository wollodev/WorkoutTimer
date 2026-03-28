import AVFoundation

final class CountdownSoundPlayer {
    private var tickPlayer: AVAudioPlayer?
    private var finishPlayer: AVAudioPlayer?

    init() {
        tickPlayer = Self.loadPlayer(resource: "beep")
        finishPlayer = Self.loadPlayer(resource: "beep_finish")
    }

    func playTick() {
        tickPlayer?.currentTime = 0
        tickPlayer?.play()
    }

    func playFinish() {
        finishPlayer?.currentTime = 0
        finishPlayer?.play()
    }

    private static func loadPlayer(resource: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "wav") else {
            return nil
        }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = 1.0
        player?.prepareToPlay()
        return player
    }
}
