
import UIKit

class AudioMessageCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: SYLabelLight!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var microphoneImageView: SYDesignableImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var audioView: UIView!
    
    var isAudioRecordStarted: Bool = false
    var audioRecordTimer: Timer?
    var audioRecordDuration: TimeInterval = 0
    var audioRecordTime: TimeInterval = 0
    var messageFileDataModel: MessageFileDataModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func startPlayingAudio() {
        self.isAudioRecordStarted = true
        playButton.setImage(UIImage(named: "pause_icon_chat"), for: .normal)
        
     //   audioRecordDuration = messageFileDataModel?.audioDurationSeconds()
        audioRecordTime = audioRecordDuration
        startAudioRecordTimer()

    }
    
    func startAudioRecordTimer() {
         if let audioRecordTimer = self.audioRecordTimer {
             audioRecordTimer.invalidate()
         }

         self.audioRecordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementAudioTimer), userInfo: nil, repeats: true)
     }

       @objc func decrementAudioTimer() {
           audioRecordTime -= 1

           if audioRecordTime <= 0 {
               stopRecording()
           }
       }
    
       func stopRecording() {
           audioRecordTimer?.invalidate()
           audioRecordTimer = nil

           // audioRecorder.stop()
       }
}
