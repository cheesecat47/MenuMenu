//
//  UICustomRoundLabel.swift
//  MenuMenu
//
//  Created by refo on 2020/06/14.
//  Copyright © 2020 COMP420. All rights reserved.
//

// reference
// https://stackoverflow.com/questions/33325919/uilabel-subclass-initialize-with-custom-color/33326273

import UIKit

class UICustomRoundTitleLabel: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = CGColor.init(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        self.layer.borderWidth = 1.0
        
        self.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: 1.0, green: 210/256, blue: 88/256, alpha: 1))
        self.tintColor = UIColor.black
        
        self.adjustsFontSizeToFitWidth = true
    }
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    

}
