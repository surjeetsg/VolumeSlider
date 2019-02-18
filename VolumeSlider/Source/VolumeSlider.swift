//
//  VolumeSlider.swift
//  VolumeSlider
//
//  Created by Surjeet Singh on 9/19/17.
//  Copyright © 2017 Surjeet Singh. All rights reserved.
//

import UIKit

public protocol VolumeSliderDelegate {
    func volumnSliderValueChanged(_ slider: VolumeSlider)
}

@IBDesignable
open class VolumeSlider: UIView {
    
    open var delegate: VolumeSliderDelegate?
    
    /* Set the default color of bars. */
    @IBInspectable
    open var defaultBarColor: UIColor = UIColor.lightGray
    
    /* Set the color of bars at filled state. If set `barColors` property, then `barColor`  will not used. */
    @IBInspectable
    open var barColor: UIColor = UIColor.red
    
    /* To show horizontally gradient effect on bars. It support maximum two color object in array.*/
    open var barColors: [UIColor]?
    
    /* Maximum value */
    @IBInspectable
    open var maxValue:Float = 1.0
    
    /* To set `Padding` from Top and Bottom */
    @IBInspectable
    open var verticalPadding:CGFloat = 0.0
    
    /* Set the Bar width in the current graphics state to `width'. */
    @IBInspectable
    open var barWidth:CGFloat = 5.0
    
    /* Set the Bar space between two bars. */
    @IBInspectable
    open var barSpace:CGFloat {
        set(newValue) {
            if newValue >= 0 {
                _barSpace = newValue
                numberOfBars = _barCount
                _barSpace = newValue + (self.bounds.width - drawableWidth)/(CGFloat(numberOfBars) - 1)
            }
        }
        get {
            return _barSpace
        }
    }
    
     /* Current value of Volume Slider */
    @IBInspectable
    open var currentValue:Float = 0 {
        didSet(newValue){
            updateValue(newValue)
        }
    }
    
    /*  Set to receive result value upto given decimal places */
    
    open var roundToPlaces: Int = 0
    
    fileprivate var currentSelectedBar:Int = 0
    fileprivate var colorArray = [UIColor]()
    
    private var _barSpace:CGFloat = 5.0
    private var _barCount:Int = 0
    
    fileprivate var drawableHeight: CGFloat {
        get { return (self.bounds.height - 2*verticalPadding) }
    }
    
    fileprivate var drawableWidth: CGFloat {
        get {
            return (CGFloat(numberOfBars) * barWidth + CGFloat(numberOfBars-1)*_barSpace)
        }
    }
    
    fileprivate var numberOfBars: Int {
        set {
            let reminder = self.bounds.width.truncatingRemainder(dividingBy: (barWidth+_barSpace))
            let num = self.bounds.width / (barWidth+_barSpace)
            if reminder < barWidth {
                _barCount = Int(num)
            } else {
                _barCount =  Int(num+1)
            }
        }
        get {
            return _barCount
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func gradientColorFromTwoColor(_ barColors:[UIColor]?) -> [UIColor]? {
        
        var colorArray = [UIColor]()
        
        if let colors = barColors {
            if colors.count == 1 {
                colorArray.append(colors[0])
                return colorArray
            }
            if colors.count > 1 {
                let r1 = colors[0].redValue, g1 = colors[0].greenValue, b1 = colors[0].blueValue, a1 = colors[0].alphaValue
                let r2 = colors[1].redValue, g2 = colors[1].greenValue, b2 = colors[1].blueValue, a2 = colors[1].alphaValue
                
                colorArray.append(colors[0])
                let count = CGFloat(numberOfBars-2)
                for j in 1..<numberOfBars {
                    let i = CGFloat(j)
                    
                    let color = UIColor(red:r1+i*((r2-r1)/count), green:g1+i*((g2-g1)/count), blue:b1+i*((b2-b1)/count), alpha:a1+i*((a2-a1)/count))
                    colorArray.append(color)
                }
                colorArray.append(colors[1])
                return colorArray
            }
        }
        return nil
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let tempArray = self.gradientColorFromTwoColor(barColors) {
            colorArray = tempArray
        }
        if numberOfBars > 0 {
            for i in 1...numberOfBars {
                self.drawLine(i)
            }
        }
    }
    
    
    fileprivate func drawLine(_ index: Int) {

        let x = (barWidth+_barSpace)*CGFloat(index-1) + barWidth/2
        let y:CGFloat = drawableHeight - CGFloat(index) * (drawableHeight / CGFloat(numberOfBars)) + verticalPadding
        
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setLineWidth(barWidth)
        if index <= currentSelectedBar {
            if colorArray.count > 0 {
                context?.setStrokeColor(colorArray[Int(index)].cgColor)
            } else {
                context?.setStrokeColor(barColor.cgColor)
            }
        } else {
            context?.setStrokeColor(defaultBarColor.withAlphaComponent(0.3).cgColor)
        }
        context?.move(to: CGPoint(x: x, y: y))
        context?.addLine(to: CGPoint(x: x, y: (drawableHeight+verticalPadding)))

        context?.closePath()
        context?.strokePath()
    }
    
    //MARK:- Touch event
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if self.bounds.contains(location) {
                self.calculateProgress(location)
            }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if self.bounds.contains(location) {
                self.calculateProgress(location)
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            self.calculateProgress(location)
        }
    }
    
    //MARK:-
    
    private func calculateProgress(_ point:CGPoint) {

        let progress = Float((point.x * CGFloat(maxValue)) / self.bounds.width)
        currentValue = ((progress > maxValue) ? maxValue : (progress < 0 ? 0 : progress)).rounded(toPlaces: roundToPlaces)
       
        self.updateValue(progress)
    }
    
    private func updateValue(_ value:Float) {
        currentSelectedBar = roundOfValue(value)
        if currentSelectedBar < 0 { currentSelectedBar = 0 }
        if currentSelectedBar > numberOfBars { currentSelectedBar = numberOfBars }
        self.setNeedsDisplay()
    
        delegate?.volumnSliderValueChanged(self)
    }
    
    private func roundOfValue(_ value:Float) -> Int {
        let newValue = (value * Float(numberOfBars)) / maxValue
        return Int(round(newValue))
    }
}

extension Float {
    /// Rounds the Float to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
