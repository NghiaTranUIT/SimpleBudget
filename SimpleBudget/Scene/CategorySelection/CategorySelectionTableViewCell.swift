//
//  CategorySelectionTableViewCell.swift
//  SimpleBudget
//
//  Created by khoi on 10/11/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import UIKit

final class CategorySelectionTableViewCell: UITableViewCell, NibLoadableView {
  @IBOutlet var categoryLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
