//
//  FormRowCurrency.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import WorldlineConnectKit

class FormRowCurrency: FormRowWithInfoButtonProductField {
    var integerField: FormRowField
    var fractionalField: FormRowField

    init(paymentProductField: PaymentProductField, integerField: FormRowField, fractionalField: FormRowField) {
        self.integerField = integerField
        self.fractionalField = fractionalField

        super.init(paymentProductField: paymentProductField)
    }
}
