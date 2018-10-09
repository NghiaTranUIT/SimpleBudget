//
//  MoneyInputTextField.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/9/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import UIKit

class MoneyInputTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTextField()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupTextField()
  }

  private func setupTextField() {
    addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    keyboardType = .decimalPad
  }

  @objc private func textFieldDidChange() {
    if let text = text,
      text.count > 0,
      !isValidNumber(text: text) {
      deleteBackward()
    }
  }

  private func isValidNumber(text: String) -> Bool {
    let validChars: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    return (Set(text).isSubset(of: validChars) && ((text.components(separatedBy: ".").count) <= 2))
  }
}
