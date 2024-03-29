//
//  ErrorMessageTableViewCell.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import UIKit

class ErrorMessageTableViewCell: LabelTableViewCell {

    override class var reuseIdentifier: String { return "error-cell" }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        labelView.font = UIFont.systemFont(ofSize: 12.0)
        labelView.numberOfLines = 0
        labelView.textColor = UIColor.red

        addSubview(labelView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
