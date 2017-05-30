import CoreGraphics

public class FKSystem {
    public var arms:[Arm]
    var lastArm:Arm?
    var x:Float
    var y:Float
    public var phase:Float = 0
    var speed:Float = 0.05
    
    public init(x:Float, y:Float) {
        self.x = x
        self.y = y
        arms = []
    }
    
    public func addArm(length:Float, centerAngle:Float, rotationRange:Float, phaseOffset:Float) {
        let arm = Arm(length: length, centerAngle: centerAngle, rotationRange: rotationRange, phaseOffset: phaseOffset)
        arms.append(arm)
        if let _ = lastArm {
            arm.parent = lastArm
        }
        lastArm = arm
        update()
    }
    
    public func update() {
        for arm in arms {
            arm.setPhase(pahse: phase)
            if let parent = arm.parent {
                arm.x = parent.getEndX()
                arm.y = parent.getEndY()
            }
            else {
                arm.x = x
                arm.y = y
            }
        }
        phase += speed
    }
    
    public func render(context:CGContext) {
        for arm in arms {
            arm.render(context: context)
        }
    }
    
    public func rotateArm(index:Int, angle:Float) {
        arms[index].angle = angle
    }
}
