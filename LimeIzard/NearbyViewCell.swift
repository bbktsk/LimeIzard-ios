//
//  NearbyViewCell.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit

class NearbyViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var heyButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.image = UIImage(named: "first")
        
        heyButton.layer.cornerRadius = 3
        heyButton.layer.borderWidth = 1
        heyButton.layer.borderColor = UIColor(hex: 0x3fd40d).CGColor
        heyButton.tintColor = UIColor(hex: 0x3fd40d)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
