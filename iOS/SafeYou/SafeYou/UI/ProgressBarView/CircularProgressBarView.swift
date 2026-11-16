
import UIKit

class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    var circleProgressColor =  UIColor(red: 255.0/255.0, green: 154.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 38, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 12.0
        circleLayer.strokeEnd = 1.0
        let circleColor =  UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        circleLayer.strokeColor = circleColor.cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .butt
        progressLayer.lineWidth = 12.0
        progressLayer.strokeEnd = 0
        let circleProgressColor =  circleProgressColor
        progressLayer.strokeColor = circleProgressColor.cgColor
        layer.addSublayer(progressLayer)
    }
    
    @objc func progressAnimation(duration: TimeInterval, toValue: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    @objc func updateProgress(trackColor: UIColor) {
        circleProgressColor = trackColor
        progressLayer.strokeColor = circleProgressColor.cgColor
    }
}
