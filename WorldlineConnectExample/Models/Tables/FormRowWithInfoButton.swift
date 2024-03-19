//
//  FormRowWithInfoButton.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import UIKit

class FormRowWithInfoButton: FormRow {
    var showInfoButton: Bool {
        return tooltip != nil
    }
    var tooltip: FormRowTooltip?

}
