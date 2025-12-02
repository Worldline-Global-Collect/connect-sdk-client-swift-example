//
//  CoBrandsSelectionTableViewCell.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import UIKit
import WorldlineConnectKit

class CoBrandsSelectionTableViewCell: TableViewCell {
    override class var reuseIdentifier: String { return "co-brand-selection-cell" }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let font = UIFont.systemFont(ofSize: 13)
        let underlineAttributes = [
           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
           NSAttributedString.Key.font: font
        ] as [NSAttributedString.Key: Any]?

        let cobrandsString =
            NSLocalizedString(
                "gc.general.cobrands.toggleCobrands",
                tableName: AppConstants.assetsLocalizable,
                bundle: AppConstants.assetsBundle,
                value: "",
                comment: ""
            )

        textLabel?.attributedText = NSAttributedString(string: cobrandsString, attributes: underlineAttributes)
        textLabel?.textAlignment = .right
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = accessoryAndMarginCompatibleWidth()
        let leftMargin = accessoryCompatibleLeftMargin()
        textLabel?.frame = CGRect(x: leftMargin, y: 4, width: width, height: 36)
    }
}
