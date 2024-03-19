//
//  FormRowLabel.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import UIKit

class FormRowLabel: FormRowWithInfoButton {
    var text: String
    var isBold: Bool
    init(text: String) {
        self.text = text
        self.isBold = false
    }
}
