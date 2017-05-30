import CoreGraphics

public class IKSystem {
    var x:Float
    var y:Float
    public var arms:[Arm]
    var lastArm:Arm?
    
    public init(x:Float, y:Float) {
        self.x = x
        self.y = y
        arms = []
    }
    
    public func addArm(length:Float) {
        let arm = Arm(x: 0, y: 0, length: length, angle: 0)
        
        if let lastArm = self.lastArm  {
            arm.x = lastArm.getEndX()
            arm.y = lastArm.getEndY()
            arm.parent = lastArm
        }
        else {
            arm.x = x
            arm.y = y
        }
        arms.append(arm)
        lastArm = arm
    }
    
    public func render(context:CGContext) {
        for arm in arms {
            arm.render(context: context)
        }
    }
    
    public func drag(x:Float, y:Float) {
        lastArm?.drag(x: x, y: y)
    }
    
    public func reach(x:Float, y:Float) {
        drag(x: x, y: y)
        update()
    }
    
    public func update() {
        for arm in arms {
            if let parent = arm.parent {
                arm.x = parent.getEndX()
                arm.y = parent.getEndY()
            }
            else {
                arm.x = x
                arm.y = y
            }
        }
    }
    
}
