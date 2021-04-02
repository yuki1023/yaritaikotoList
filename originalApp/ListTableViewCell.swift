//
//  ListTableViewCell.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/09/28.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton)
}

class ListTableViewCell: UITableViewCell {
    
    var delegate: ListTableViewCellDelegate?
    
    @IBOutlet var listTextLabel: UILabel!
    
    @IBOutlet var checkBoxButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func like(button: UIButton) {
            self.delegate?.didTapLikeButton(tableViewCell: self, button: button)
        }
}
