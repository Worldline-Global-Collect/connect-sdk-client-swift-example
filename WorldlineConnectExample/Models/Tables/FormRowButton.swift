//
//  FormRowButton.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import UIKit

class FormRowButton: FormRow {
    var title: String
    var target: Any
    var action: Selector
    var buttonType: ExampleButtonType = .primary

    init(title: String, target: Any, action: Selector) {
        self.title = title
        self.target = target
        self.action = action
    }
}
