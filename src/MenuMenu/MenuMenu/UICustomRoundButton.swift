//
//  UICustomRoundButton.swift
//  MenuMenu
//
//  Created by refo on 2020/06/14.
//  Copyright © 2020 COMP420. All rights reserved.
//

// reference
// https://yucaroll.tistory.com/4

import UIKit

class UICustomRoundButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = CGColor.init(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        self.layer.borderWidth = 1.0
        
        self.contentEdgeInsets.top = 5.0
        self.contentEdgeInsets.bottom = 5.0
        self.contentEdgeInsets.left = 10.0
        self.contentEdgeInsets.right = 10.0
        
        self.backgroundColor = UIColor(cgColor: CGColor.init(srgbRed: 1.0, green: 210/256, blue: 88/256, alpha: 1))
        self.tintColor = UIColor.black
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
