//
//  SuperView.swift
//  HeatMap
//
//  Created by Anand on 03/08/21.
//

import UIKit

class SuperView: UIView {

    var view_content: UIView!
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required public init?(coder aDecoder : NSCoder ) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        view_content = loadViewFromNib_()
        view_content.frame = bounds
        view_content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view_content.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view_content)
    }
    
    private func loadViewFromNib_() -> UIView {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }

}
