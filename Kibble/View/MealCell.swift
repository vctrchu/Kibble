//
//  MealCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-22.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import SwipeCellKit

@available(iOS 13.0, *)
class MealCell: SwipeTableViewCell {

    let typeImage = UIImageView()
    let nameLabel = UILabel()
    let cellView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        addSubview(cellView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(typeImage)

        cellView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        cellView.layer.cornerRadius = 12
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.adjusted),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.adjusted),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.adjusted),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        typeImage.translatesAutoresizingMaskIntoConstraints = false
        typeImage.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeImage.heightAnchor.constraint(equalToConstant: 35),
            typeImage.widthAnchor.constraint(equalToConstant: 35),
            typeImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            typeImage.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10.adjusted)
        ])

        nameLabel.textColor = UIColor.black
        nameLabel.font = Device.roundedFont(ofSize: .title2, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 10).isActive = true

    }

    func configureCell(isFed status: String, name: String, type: String) {
        nameLabel.text = name
        switch type {
        case "dry":
            typeImage.image = #imageLiteral(resourceName: "Dry")
        case "wet":
            typeImage.image = #imageLiteral(resourceName: "Wet")
        default:
            typeImage.image = #imageLiteral(resourceName: "Treat")
        }
        if status == "true" {
            typeImage.alpha = 0.3
            nameLabel.alpha = 0.3
            cellView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.9294117647, blue: 0.4745098039, alpha: 1)
        } else {
            typeImage.alpha = 1
            nameLabel.alpha = 1
            cellView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
