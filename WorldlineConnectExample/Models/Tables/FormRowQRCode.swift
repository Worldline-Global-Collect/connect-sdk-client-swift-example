//
//  FormRowQRCode.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/06/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

import UIKit

class FormRowQRCode: FormRowImage {
    convenience init(qrCodeString: String) {
        let data = qrCodeString.decode()
        // let data = qrCodeString.data(using: String.Encoding.utf8)
        self.init(data: data)
    }
    init(data: Data) {
        let image = UIImage(data: data)
        super.init(image: image!)
    }
}
