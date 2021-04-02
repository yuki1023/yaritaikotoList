//
//  NonachievementTableViewCell.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/10/08.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//

import UIKit

protocol NonachievementTableViewCellDelegate {
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton)
}

class NonachievementTableViewCell: UITableViewCell {
    
    var delegate: NonachievementTableViewCellDelegate?
    
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
//            self.delegate?.didTapLikeButton(tableViewCell: self, button: button)
        }
}

