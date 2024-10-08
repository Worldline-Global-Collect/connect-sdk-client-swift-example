//
//  FormRowsConverter.swift
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2016 Worldline Global Collect. All rights reserved.
//

import Foundation
import WorldlineConnectKit
import UIKit

class FormRowsConverter {

    func formRows(from inputData: PaymentProductInputData, confirmedPaymentProducts: Set<String>) -> [FormRow] {
        var rows: [FormRow] = []
        let paymentProductFields = inputData.paymentItem.fields.paymentProductFields

        for field in paymentProductFields {
            let isPartOfAccountOnFile = inputData.fieldIsPartOfAccountOnFile(paymentProductFieldId: field.identifier)
            let value: String
            let isEnabled: Bool

            if isPartOfAccountOnFile {
                let mask = field.displayHints?.mask
                value = inputData.accountOnFile.maskedValue(forField: field.identifier, mask: mask)
                isEnabled = !inputData.fieldIsReadOnly(paymentProductFieldId: field.identifier)
            } else {
                value = inputData.maskedValue(forField: field.identifier)
                isEnabled = true
            }

            var row: FormRow = labelFormRow(from: field, paymentProduct: inputData.paymentItem.identifier)
            rows.append(row)

            if let formElementType = field.displayHints?.formElement.type {
                switch formElementType {
                case .listType:
                    row = listFormRow(from: field, value: value, isEnabled: isEnabled)
                case .textType:
                    row =
                    textFieldFormRow(
                        from: field,
                        paymentItem: inputData.paymentItem,
                        value: value,
                        isEnabled: isEnabled,
                        confirmedPaymentProducts: confirmedPaymentProducts
                    )
                case .currencyType:
                    row =
                    currencyFormRow(from: field, paymentItem: inputData.paymentItem, value: value, isEnabled: isEnabled)
                case .dateType:
                    row = dateFormRow(from: field, value: value, isEnabled: isEnabled)
                case .boolType:
                    rows.removeLast()
                    row = switchFormRow(
                        from: field,
                        paymentItem: inputData.paymentItem,
                        value: value,
                        isEnabled: isEnabled
                    )
                }
                rows.append(row)
            }
        }

        return rows
    }

    static func errorMessage(for error: ValidationError, withCurrency: Bool) -> String {
        let errorClass = error.self
        let errorMessageFormat = "gc.general.paymentProductFields.validationErrors.%@.label"
        var errorMessageKey: String
        var errorMessageValue: String
        var errorMessage: String
        if let lengthError = errorClass as? ValidationErrorLength {
            if lengthError.minLength == lengthError.maxLength {
                errorMessageKey = String(format: errorMessageFormat, "length.exact")
            } else if lengthError.minLength == 0 && lengthError.maxLength > 0 {
                errorMessageKey = String(format: errorMessageFormat, "length.max")
            } else if lengthError.minLength > 0 && lengthError.maxLength > 0 {
                errorMessageKey = String(format: errorMessageFormat, "length.between")
            } else {
                // this case never happens
                errorMessageKey = ""
            }

            let errorMessageValueWithPlaceholders =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
            let errorMessageValueWithPlaceholder =
                errorMessageValueWithPlaceholders.replacingOccurrences(
                    of: "{maxLength}",
                    with: String(lengthError.maxLength)
                )
            errorMessage =
                errorMessageValueWithPlaceholder.replacingOccurrences(
                    of: "{minLength}",
                    with: String(lengthError.minLength)
                )
        } else if let rangeError = errorClass as? ValidationErrorRange {
            errorMessageKey = String(format: errorMessageFormat, "length.between")
            let errorMessageValueWithPlaceholders =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
            var minString = ""
            var maxString = ""
            if withCurrency {
                minString = String(format: "%.2f", Double(rangeError.minValue) / 100)
                maxString = String(format: "%.2f", Double(rangeError.maxValue) / 100)
            } else {
                minString = "\(Int(rangeError.minValue))"
                maxString = "\(Int(rangeError.maxValue))"
            }
            let errorMessageValueWithPlaceholder =
                errorMessageValueWithPlaceholders.replacingOccurrences(of: "{maxValue}", with: String(maxString))
            errorMessage =
                errorMessageValueWithPlaceholder.replacingOccurrences(of: "{minValue}", with: String(minString))

        } else if let errorMessageFromClass = errorClass.errorMessageKey() {
            errorMessageKey = String(format: errorMessageFormat, errorMessageFromClass)
            errorMessageValue =
                NSLocalizedString(
                    errorMessageKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
            errorMessage = errorMessageValue
        } else {
            errorMessage = ""
            NSException(
                name: NSExceptionName(rawValue: "Invalid validation error"),
                reason: "Validation error \(error) is invalid",
                userInfo: nil
            ).raise()
        }

        return errorMessage
    }

    func textFieldFormRow(
        from field: PaymentProductField,
        paymentItem: PaymentItem,
        value: String,
        isEnabled: Bool,
        confirmedPaymentProducts: Set<String>?
    ) -> FormRowTextField {
        var placeholderKey =
            "gc.general.paymentProducts.\(paymentItem.identifier).paymentProductFields.\(field.identifier).placeholder"
        var placeholderValue =
            NSLocalizedString(
                placeholderKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        if placeholderKey == placeholderValue {
            placeholderKey = "gc.general.paymentProductFields.\(field.identifier).placeholder"
            placeholderValue =
                NSLocalizedString(
                    placeholderKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
        }

        let keyboardType: UIKeyboardType
        let preferredInputType = field.displayHints?.preferredInputType ?? .stringKeyboard
        switch preferredInputType {
        case .integerKeyboard:
            keyboardType = .numberPad

        case .emailAddressKeyboard:
            keyboardType = .emailAddress

        case .phoneNumberKeyboard:
            keyboardType = .phonePad

        case .stringKeyboard, .noKeyboard, .dateKeyboard:
            keyboardType = .default
        }

        let formField =
            FormRowField(
                text: value,
                placeholder: placeholderValue,
                keyboardType: keyboardType,
                isSecure: field.displayHints?.obfuscate ?? false
            )
        let row = FormRowTextField(paymentProductField: field, field: formField)
        row.isEnabled = isEnabled

        if field.identifier == "cardNumber" {
            if let confirmedPaymentProducts = confirmedPaymentProducts,
               confirmedPaymentProducts.contains(paymentItem.identifier) {
                row.logo = paymentItem.displayHints.logoImage
            } else {
                row.logo = nil
            }
        }

        setTooltipForFormRow(row, with: field, paymentItem: paymentItem)

        return row
    }

    func currencyFormRow(
        from field: PaymentProductField,
        paymentItem: PaymentItem,
        value: String,
        isEnabled: Bool
    ) -> FormRowCurrency {

        var placeholderKey =
            "gc.general.paymentProducts.\(paymentItem.identifier).paymentProductFields.\(field.identifier).placeholder"
        var placeholderValue =
            NSLocalizedString(
                placeholderKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        if placeholderKey == placeholderValue {
            placeholderKey = "gc.general.paymentProductFields.\(field.identifier).placeholder"
            placeholderValue =
                NSLocalizedString(
                    placeholderKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
        }

        let keyboardType: UIKeyboardType
        let preferredInputType = field.displayHints?.preferredInputType ?? .stringKeyboard
        switch preferredInputType {
        case .integerKeyboard:
            keyboardType = .numberPad

        case .emailAddressKeyboard:
            keyboardType = .emailAddress

        case .phoneNumberKeyboard:
            keyboardType = .phonePad

        case .stringKeyboard, .noKeyboard, .dateKeyboard:
            keyboardType = .default
        }

        let integerPart = Int((Double(value) ?? 0) / 100)
        let fractionalPart = Int(llabs((Int64(value) ?? 0) % 100))

        let obfuscate = field.displayHints?.obfuscate ?? false

        let integerField =
            FormRowField(
                text: "\(integerPart)",
                placeholder: placeholderValue,
                keyboardType: keyboardType,
                isSecure: obfuscate
            )
        let fractionalField =
            FormRowField(
                text: String(format: "%02d", fractionalPart),
                placeholder: "",
                keyboardType: keyboardType,
                isSecure: obfuscate
            )

        let row =
            FormRowCurrency(paymentProductField: field, integerField: integerField, fractionalField: fractionalField)

        row.integerField = integerField
        row.fractionalField = fractionalField
        row.isEnabled = isEnabled

        setTooltipForFormRow(row, with: field, paymentItem: paymentItem)

        return row
    }

    func switchFormRow(
        from field: PaymentProductField,
        paymentItem: PaymentItem,
        value: String,
        isEnabled: Bool
    ) -> FormRowSwitch {
        let descriptionKey =
            String(
                format: "gc.general.paymentProducts.%@.paymentProductFields.%@.label",
                paymentItem.identifier,
                field.identifier
            )
        let descriptionValue =
            NSLocalizedString(
                descriptionKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: "Accept {link}"
            )
        let labelKey =
            String(
                format: "gc.general.paymentProducts.%@.paymentProductFields.%@.link.label",
                paymentItem.identifier,
                field.identifier
            )
        let labelValue =
            NSLocalizedString(
                labelKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        let nsDescriptionValue = descriptionValue as NSString
        let range = nsDescriptionValue.range(of: "{link}")
        let attrString = NSMutableAttributedString(string: descriptionValue)
        let linkString =
            NSAttributedString(
                string: labelValue,
                attributes: [NSAttributedString.Key.link: (field.displayHints?.link?.absoluteString ?? "")]
            )
        if range.length > 0 {
            attrString.replaceCharacters(in: range, with: linkString)
        }

        let row =
            FormRowSwitch(
                title: attrString,
                isOn: value == "true",
                target: nil,
                action: nil,
                paymentProductField: field
            )
        row.isEnabled = isEnabled

        return row
    }

    func dateFormRow(from field: PaymentProductField, value: String, isEnabled: Bool) -> FormRowDate {
        let row = FormRowDate(paymentProductField: field, value: value)
        row.isEnabled = isEnabled
        return row
    }

    func setTooltipForFormRow(_ row: FormRowWithInfoButton, with field: PaymentProductField, paymentItem: PaymentItem) {
        if field.displayHints?.tooltip?.imagePath != nil {
            let tooltip = FormRowTooltip()
            // swiftlint:disable line_length
            var tooltipTextKey = "gc.general.paymentProducts.\(paymentItem.identifier).paymentProductFields.\(field.identifier).tooltipText"
            // swiftlint:enable line_length
            var tooltipTextValue =
                NSLocalizedString(
                    tooltipTextKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
            if tooltipTextKey == tooltipTextValue {
                tooltipTextKey = "gc.general.paymentProductFields.\(field.identifier).tooltipText"
                tooltipTextValue =
                    NSLocalizedString(
                        tooltipTextKey,
                        tableName: SDKConstants.kSDKLocalizable,
                        bundle: AppConstants.sdkBundle,
                        value: "",
                        comment: ""
                    )
            }
            tooltip.text = tooltipTextValue
            tooltip.image = field.displayHints?.tooltip?.image
            row.tooltip = tooltip
        }
    }

    func listFormRow(from field: PaymentProductField, value: String, isEnabled: Bool) -> FormRowList {
        let row = FormRowList(paymentProductField: field)

        if let valueMapping = field.displayHints?.formElement.valueMapping {
            for item: ValueMappingItem in valueMapping where item.displayName != nil {
                row.items.append(item)
            }
        }

        row.selectedRow = row.items.map({ $0.value }).firstIndex(of: value) ?? 0
        row.isEnabled = isEnabled
        return row
    }

    func labelFormRow(from field: PaymentProductField, paymentProduct paymentProductId: String) -> FormRowLabel {
        var labelKey = "gc.general.paymentProducts.\(paymentProductId).paymentProductFields.\(field.identifier).label"
        var labelValue =
            NSLocalizedString(
                labelKey,
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )

        if labelKey == labelValue {
            labelKey = "gc.general.paymentProductFields.\(field.identifier).label"
            labelValue =
                NSLocalizedString(
                    labelKey,
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
        }

        return FormRowLabel(text: labelValue)
    }

}
