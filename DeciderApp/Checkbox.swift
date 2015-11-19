//
//  Checkbox.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/19/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

protocol CheckboxDelegate {
    
    func checkboxDidFinishWithSelectedVenue(venue: Venue?)
    
}

@IBDesignable
class Checkbox: UIView {
    
    
    
    // MARK: - Border Properties
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            if borderWidth != oldValue {
                layer.borderWidth = borderWidth
            }
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            if borderColor != oldValue {
                layer.borderColor = borderColor.CGColor
            }
        }
    }
    
    // MARK: - Check Mark Properties
    @IBInspectable var checkWidth: CGFloat = 1 {
        didSet {
            if checkWidth != oldValue && isChecked {
                checkLayer?.lineWidth = checkWidth
            }
        }
    }
    @IBInspectable var checkColor: UIColor = UIColor.blackColor() {
        didSet {
            if checkColor != oldValue && isChecked {
                checkLayer?.strokeColor = checkColor.CGColor
            }
        }
    }
    
    private var checkLayer: CAShapeLayer? // Check mark layer - to be animated when added to the views layer
    @IBInspectable var isChecked: Bool = false {
        didSet {
            if isChecked != oldValue {
                let layerWidth = layer.frame.width
                let layerHeight = layer.frame.height
                
                // Add or remove check mark
                if isChecked {
                    // Verify if check layer is nil
                    // To avoid duplicates
                    if checkLayer == nil {
                        checkLayer = CAShapeLayer()
                        
                        let checkPath = UIBezierPath()
                        checkPath.moveToPoint(CGPoint(x: layerWidth / 8, y: layerHeight * 5 / 8))
                        checkPath.addLineToPoint(CGPoint(x: layerWidth * 3 / 8, y: layerHeight * 7 / 8))
                        checkPath.addLineToPoint(CGPoint(x: layerWidth * 7 / 8, y: layerHeight / 8))
                        
                        checkLayer?.path = checkPath.CGPath
                        checkLayer?.opacity = 1
                        checkLayer?.strokeColor = checkColor.CGColor
                        checkLayer?.fillColor = nil
                        checkLayer?.lineWidth = checkWidth
                        
                        layer.addSublayer(checkLayer!)
                    }
                    
                    // Add animation only when target is not interface builder
                    #if TARGET_INTERFACE_BUILDER
                    #else
                        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
                        pathAnimation.duration = 0.2
                        pathAnimation.fromValue = 0
                        pathAnimation.toValue = 1
                        checkLayer?.addAnimation(pathAnimation, forKey: "strokeEndShowAnimation")
                    #endif
                    
                } else {
                    #if TARGET_INTERFACE_BUILDER
                    #else
                        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
                        pathAnimation.duration = 0.2
                        pathAnimation.fromValue = 1
                        pathAnimation.toValue = 0
                        
                        // Create completion block to commit AFTER animation
                        CATransaction.setCompletionBlock({ () -> Void in
                            // Verify if isChecked is still false
                            // In case if checked again DURING animation
                            if !self.isChecked {
                                self.checkLayer?.removeFromSuperlayer()
                                self.checkLayer = nil
                            }
                        })
                        checkLayer?.addAnimation(pathAnimation, forKey: "strokeEndHideAnimation")
                        CATransaction.commit()
                    #endif
                }
            }
        }
    }
    
    // MARK: - Initialization
    
    private func renderLayer() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }
    
    private var tap: UITapGestureRecognizer?
    private func addTapGestureRecognizer() {
        tap = UITapGestureRecognizer(target: self, action: Selector("didTapView:"))
        addGestureRecognizer(tap!)
    }
    private func commonInitialization() {
        renderLayer()
        addTapGestureRecognizer()
    }
    
    // MARK: Live Render
    override func prepareForInterfaceBuilder() {
        renderLayer()
    }
    
    // MARK: Interface Builder
    override func awakeFromNib() {
        commonInitialization()
    }
    
    // MARK: Programmatic
    
    var indexPath: NSIndexPath?
    var datasource: [Venue]?
    var delegate: CheckboxDelegate?
    
    init(frame: CGRect, indexPath: NSIndexPath) {
        self.indexPath = indexPath
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        self.indexPath = nil
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.indexPath = nil
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Tap Event
    func didTapView(sender: AnyObject) {
        isChecked = !isChecked
        if let delegate = self.delegate {
            guard let datasource = self.datasource, indexPath = self.indexPath else { return }
            delegate.checkboxDidFinishWithSelectedVenue(datasource[indexPath.row])
        }
//        print(self.indexPath)
    }
}

