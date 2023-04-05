
import Foundation
import UIKit

extension UIView {
   
    func addShadow(cornerRadius: CGFloat, offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    func setShadowWithCornerRadius(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadoeOpacity: Float = 1, shadowRadius: CGFloat = 15){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadoeOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = shadowRadius
    }
}
