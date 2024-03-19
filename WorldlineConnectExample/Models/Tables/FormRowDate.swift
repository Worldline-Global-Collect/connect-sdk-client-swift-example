//
//  FormRowDate.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 22/10/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

import Foundation
import WorldlineConnectKit

class FormRowDate: FormRowWithProductField {

    var date: Date
    init(paymentProductField field: PaymentProductField, value: String) {
        if value != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"

            date = formatter.date(from: value) ?? Date()

        } else {
            date = Date()
        }

        super.init(paymentProductField: field)
    }

}
