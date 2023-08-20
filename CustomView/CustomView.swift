//
//  CustomView.swift
//  CustomView
//
//  Created by andy on 2023/7/30.
//

import UIKit

class CustomView: UIView {

 
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
