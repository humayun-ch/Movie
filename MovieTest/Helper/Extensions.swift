//
//  Extensions.swift
//  MovieTest
//
//  Created by Macbook Pro on 7/13/22.
//

import Foundation
import UIKit

//MARK: - ************ UIView related ************
extension UIView {
    
    func anchor (top : NSLayoutYAxisAnchor? = nil , left: NSLayoutXAxisAnchor?  = nil , bottom : NSLayoutYAxisAnchor?  = nil , right : NSLayoutXAxisAnchor?  = nil ,centerX : NSLayoutXAxisAnchor? = nil , centerY : NSLayoutYAxisAnchor? = nil, paddingTop : CGFloat = 0 , paddingLeft : CGFloat = 0 , paddingBottom : CGFloat = 0 , paddingRight : CGFloat = 0 ,xConstant : CGFloat = 0, yConstant : CGFloat = 0, width : CGFloat = 0 , height : CGFloat = 0 ){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top , constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left , constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom , constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right , constant: -paddingRight).isActive = true
        }
        
        if let centerX = centerX{
            self.centerXAnchor.constraint(equalTo: centerX, constant: xConstant).isActive = true
        }
        
        if let centerY = centerY{
            self.centerYAnchor.constraint(equalTo: centerY, constant: yConstant).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func setBorder(borderWidth : CGFloat = 1 , borderColor : UIColor = .red){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

//MARK: - ************ UIColor related ************
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MARK: - ************ UINavigationController related ************
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isHidden = true
        self.navigationBar.barStyle = .black
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

