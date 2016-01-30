//
//  CircularUIView.swift
//  CORemote
//
//  Created by denis lavrov on 29/01/16.
//  Copyright © 2016 Denis Lavrov. All rights reserved.
//

import UIKit

@IBDesignable
class CircularUIView: UIView {

    var backgroundLayer: CAShapeLayer!
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.clearColor()
    @IBInspectable var strokeColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var lineWidth: CGFloat = 1.0
	@IBInspectable var planetSpacing: CGFloat = 50
	var master: UIView? = nil
	var maxDiameter: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLayer()
		if subviews.count == 0 {
			return
		}
		let orbitNumber = numberOfOrbits()
		print("Number of orbits", orbitNumber)
		let viewDiameter = orbitRadius(orbitNumber - 1) * 2 + maxDiameter
		print(frame)
		frame.size = CGSize(width: viewDiameter, height: viewDiameter)
		print(frame)
		//frame = CGRect(x: center.x - viewDiameter, y: , width: viewDiameter, height: viewDiameter)
		let boundCenter = CGPoint(x: frame.width/2, y: frame.height/2)
		print(boundCenter)
		var layedOut: [UIView] = []
		for orbit in 0..<orbitNumber {
			print("Orbit #", orbit)
			let orbitViews = numberAtOrbit(orbit)
			let angle = (2 * M_PI) / Double(orbitViews)
			let thisRadius = orbitRadius(orbit)
			var nLayedOrbit: UInt = 0
			print("Radius: ", thisRadius)
			for view in subviews {
				if !layedOut.contains(view){
					if (nLayedOrbit == orbitViews) {
						break
					}
					let viewAngle = Double(nLayedOrbit) * angle
					nLayedOrbit++
					let centerPoint = CircularUIView.toCartesian(thisRadius, angle: CGFloat(viewAngle), offset: boundCenter)
					print(centerPoint)
					view.center = centerPoint
					layedOut.append(view)
				}
			}
		}
    }
	
	static func toCartesian(radius: CGFloat, angle: CGFloat, offset: CGPoint) -> CGPoint {
		let x = radius * cos(angle)
		let y = radius * sin(angle)
		return CGPoint(x: x + offset.x, y: y + offset.y)
	}
	
	static func calcDiameter(view: UIView) -> CGFloat{
		return sqrt(pow(view.bounds.width, 2) + pow(view.bounds.height, 2))
	}
	
	func orbitalSpacing() -> CGFloat{
		maxDiameter = 0.0
		for subview in self.subviews {
			let diameter = CircularUIView.calcDiameter(subview)
			if diameter > maxDiameter  && subview != master{
				maxDiameter = diameter
			}
		}
		return maxDiameter + planetSpacing
	}
	
	func orbitRadius(orbit: UInt) -> CGFloat{
		var masterDiameter: CGFloat = 0.0
		if master != nil {
			masterDiameter = CircularUIView.calcDiameter(master!)
		}
		return (masterDiameter + maxDiameter)/2 + maxDiameter * CGFloat(orbit) + planetSpacing
	}
	
	func orbitalAngle(orbit: UInt) -> CGFloat {
		let opposite = orbitalSpacing()/2
		let hypotenuse = orbitRadius(orbit)
		return asin(opposite/hypotenuse)
	}
	
	func numberAtOrbit(orbit: UInt) -> UInt {
		return UInt((2 * M_PI) / Double(orbitalAngle(orbit)))
	}
	
	func numberOfOrbits() -> UInt{
		var cumulativeElements: UInt = 0
		var orbitNumber: UInt = 0
		while cumulativeElements < UInt(subviews.count) {
			cumulativeElements += numberAtOrbit(orbitNumber)
			orbitNumber++
		}
		return orbitNumber
	}
	
    func setBackgroundLayer() {
        self.backgroundColor = UIColor.clearColor()
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            let rect = CGRectInset(bounds, lineWidth/2, lineWidth/2)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.strokeColor = strokeColor.CGColor
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.CGColor
            backgroundLayer.shadowColor = UIColor.blackColor().CGColor
            backgroundLayer.shadowOffset = CGSize(width: 1, height: 1)
            backgroundLayer.shadowRadius = 5.0
            backgroundLayer.shadowOpacity = 0.3
        }
        backgroundLayer.frame = layer.bounds
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
