//
//  RoundedButton.swift
//  SmartInterphone
//
//  Created by Ladjemi Kais on 2/12/19.
//  Copyright © 2019 iof. All rights reserved.
//

import UIKit


@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.setupView()
        }
    }
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1){
        didSet {
            self.setupView()
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleEdgeInsets.top = 2
        self.titleEdgeInsets.bottom = 2
        self.titleEdgeInsets.left = 4
        self.titleEdgeInsets.right = 4
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 4
        self.layer.borderColor = borderColor.cgColor 
    }
}
