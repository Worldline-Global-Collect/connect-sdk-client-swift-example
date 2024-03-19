//
//  FormRowWithInfoButtonProductField.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/02/2023.
//  Copyright © 2023 Worldline Global Collect. All rights reserved.
//

import Foundation
import WorldlineConnectKit

class FormRowWithInfoButtonProductField: FormRowWithInfoButton {
    var paymentProductField: PaymentProductField

    init(paymentProductField: PaymentProductField) {
        self.paymentProductField = paymentProductField

        super.init()
    }
}
