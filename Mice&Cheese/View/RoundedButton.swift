//
//  RoundedButton.swift
//  Mice&Cheese
//
//  Created by onur hüseyin çantay on 20.10.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
        self.clipsToBounds = true
    }

}
