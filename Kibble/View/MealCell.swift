//
//  MealCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-22.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

    @IBOutlet weak var isFedImage: UIImageView!
    @IBOutlet weak var type: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mealDescription: UILabel!

    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(cellView)
        cellView.addSubview(dayLabel)
        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        dayLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true

    }

    func configureCell(isFed status: Bool, name: String, type: String) {
        self.name.text = name
        switch type {
        case "dry":
            self.type.image = #imageLiteral(resourceName: "DryFoodIcon")
        case "wet":
            self.type.image = #imageLiteral(resourceName: "WetFoodIcon")
        default:
            self.type.image = #imageLiteral(resourceName: "TreatFoodIcon")
        }
        if status {
            isFedImage.isHidden = false
        } else {
            isFedImage.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
