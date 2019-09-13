//
//  MealTableViewCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-11.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {
    
    @IBOutlet weak var isFedImage: UIImageView!
    @IBOutlet weak var mealTitle: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    
    func configureCell(isFed status: Bool, mealTitle: String, mealDescription: String) {
        self.mealTitle.text = mealTitle
        self.mealDescription.text = mealDescription
        if status {
            isFedImage.image = UIImage(named: "Check")
        } else {
            isFedImage.image = UIImage(named: "Cancel")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
