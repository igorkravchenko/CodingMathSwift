import UIKit
import PlaygroundSupport

class Point : XYProvidable {
    var x:Float
    var y:Float
    
    init(x:Float = 0, y:Float = 0) {
        self.x = x
        self.y = y
    }
}

extension Point {
    var cgPoint:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension UIColor {
    convenience init(color24:Int) {
        let r = color24 >> 16
        let g = color24 >> 8 & 0xFF
        let b = color24 & 0xFF
        self.init(red:CGFloat(r) / 0xFF, green:CGFloat(g) / 0xFF, blue:CGFloat(b) / 0xFF, alpha: 1)
    }
}

class SampleView : BaseView {
    var leg0:FKSystem!
    var leg1:FKSystem!
    
    let topCenterLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 150, height: 20))
    let topCenterSlider = UISlider(frame:CGRect(x: 0, y: 20, width: 150, height: 40))
    
    let topRangeLabel = UILabel(frame:CGRect(x: 0, y: 80, width: 150, height: 20))
    let topRangeSlider = UISlider(frame:CGRect(x: 0, y: 100, width: 150, height: 40))
    
    let bottomCenterLabel = UILabel(frame:CGRect(x: 0, y: 180, width: 150, height: 20))
    let bottomCenterSlider = UISlider(frame:CGRect(x: 0, y: 200, width: 150, height: 40))
    
    let bottomRangeLabel = UILabel(frame:CGRect(x: 0, y: 280, width: 150, height: 20))
    let bottomRangeSlider = UISlider(frame:CGRect(x: 0, y: 300, width: 150, height: 40))
    
    let bottomPhaseLabel = UILabel(frame:CGRect(x: 0, y: 380, width: 150, height: 20))
    let bottomPhaseSlider = UISlider(frame:CGRect(x: 0, y: 400, width: 150, height: 40))
    
    
    override func setup() {
        leg0 = FKSystem(x: width / 2, y: height / 2)
        leg1 = FKSystem(x: width / 2, y: height / 2)
        leg1.phase = Float.pi
        leg0.addArm(length: 200, centerAngle: Float.pi / 2, rotationRange: Float.pi / 4, phaseOffset: 0)
        leg0.addArm(length: 180, centerAngle: 0.87, rotationRange: 0.87, phaseOffset: -1.5)
        leg1.addArm(length: 200, centerAngle: Float.pi / 2, rotationRange: Float.pi / 4, phaseOffset: 0)
        leg1.addArm(length: 180, centerAngle: 0.87, rotationRange: 0.87, phaseOffset: -1.5)
        
        topCenterLabel.text = "top center"
        addSubview(topCenterLabel)
        topCenterSlider.minimumValue = 0
        topCenterSlider.maximumValue = 3.14
        topCenterSlider.value = 1.57
        topCenterSlider.addTarget(self, action: #selector(handleValueChange(slider:)), for: .valueChanged)
        addSubview(topCenterSlider)
        
        topRangeLabel.text = "top range"
        addSubview(topRangeLabel)
        topRangeSlider.minimumValue = 0
        topRangeSlider.maximumValue = 1.57
        topRangeSlider.value = 0.77
        topRangeSlider.addTarget(self, action: #selector(handleValueChange(slider:)), for: .valueChanged)
        addSubview(topRangeSlider)
        
        bottomCenterLabel.text = "bottom center"
        addSubview(bottomCenterLabel)
        bottomCenterSlider.minimumValue = 0.87
        bottomCenterSlider.maximumValue = 1.5
        bottomCenterSlider.value = 0.87
        bottomCenterSlider.addTarget(self, action: #selector(handleValueChange(slider:)), for: .valueChanged)
        addSubview(bottomCenterSlider)
        
        bottomRangeLabel.text = "bottom range"
        addSubview(bottomRangeLabel)
        bottomRangeSlider.minimumValue = 0
        bottomRangeSlider.maximumValue = 1.5
        bottomRangeSlider.value = 0.87
        bottomRangeSlider.addTarget(self, action: #selector(handleValueChange(slider:)), for: .valueChanged)
        addSubview(bottomRangeSlider)
        
        bottomPhaseLabel.text = "bottom phase"
        addSubview(bottomPhaseLabel)
        bottomPhaseSlider.minimumValue = 0
        bottomPhaseSlider.maximumValue = 3
        bottomPhaseSlider.value = 1.5
        bottomPhaseSlider.addTarget(self, action: #selector(handleValueChange(slider:)), for: .valueChanged)
        addSubview(bottomPhaseSlider)
    }
    
    override func update(context: CGContext) {
        leg0.update()
        leg1.update()
        leg0.render(context: context)
        leg1.render(context: context)
        requestAnimationFrame(#selector(setNeedsDisplay as () -> ()))
    }
    
    func handleValueChange(slider:UISlider) {
        switch slider {
        case topCenterSlider:
            leg0.arms[0].centerAngle = slider.value
            leg1.arms[0].centerAngle = slider.value
        case topRangeSlider:
            leg0.arms[0].rotationRange = slider.value
            leg1.arms[0].rotationRange = slider.value
        case bottomCenterSlider:
            leg0.arms[1].centerAngle = slider.value
            leg1.arms[1].centerAngle = slider.value
        case bottomRangeSlider:
            leg0.arms[1].rotationRange = slider.value
            leg1.arms[1].rotationRange = slider.value
        case bottomPhaseSlider:
            leg0.arms[1].phaseOffset = slider.value
            leg1.arms[1].phaseOffset = slider.value
        default:
            break
        }
    }
}

let view = SampleView(frame:CGRect(x: 0, y:0, width: 800, height: 600))
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

