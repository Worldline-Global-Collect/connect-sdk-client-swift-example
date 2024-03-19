//
// Created for Worldline Global Collect on 20/04/2021.
// Copyright (c) 2021 Worldline Global Collect. All rights reserved.
//

import Foundation

protocol ParseJsonTarget {
    func success(sessionData data: StartPaymentParsedJsonData)
}
