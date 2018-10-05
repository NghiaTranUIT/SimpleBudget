//
//  SpendingListTableViewCell.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import UIKit

class SpendingListTableViewCell: UITableViewCell, NibLoadableView {
  @IBOutlet var noteLabel: UILabel!
  @IBOutlet var amountLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
