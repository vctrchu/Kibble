//
//  MealCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-22.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MealCell: UITableViewCell {

    var isFedImage: UIImageView = UIImageView()
    var typeImage: UIImageView = UIImageView()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = Device.roundedFont(ofSize: .title2, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.6765974164, blue: 1, alpha: 1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(typeImage)
        cellView.addSubview(isFedImage)
        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.adjusted),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.adjusted),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.adjusted),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        typeImage.translatesAutoresizingMaskIntoConstraints = false
        typeImage.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            typeImage.heightAnchor.constraint(equalToConstant: 60.adjusted),
            typeImage.widthAnchor.constraint(equalToConstant: 60.adjusted),
            typeImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            typeImage.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10.adjusted)
        ])

        nameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 10).isActive = true

        isFedImage.translatesAutoresizingMaskIntoConstraints = false
        isFedImage.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            isFedImage.heightAnchor.constraint(equalToConstant: 30.adjusted),
            isFedImage.widthAnchor.constraint(equalToConstant: 30.adjusted),
            isFedImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            isFedImage.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20.adjusted)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(isFed status: String, name: String, type: String) {
        nameLabel.text = name
        switch type {
        case "dry":
            typeImage.image = #imageLiteral(resourceName: "DryFoodIcon")
        case "wet":
            typeImage.image = #imageLiteral(resourceName: "WetFoodIcon")
        default:
            typeImage.image = #imageLiteral(resourceName: "TreatFoodIcon")
        }
        if status == "true" {
            isFedImage.isHidden = false
            isFedImage.image = #imageLiteral(resourceName: "isFedCheckmark")
        } else {
            isFedImage.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
