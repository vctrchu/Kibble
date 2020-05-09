//
//  MemberCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-05.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    // MARK: - Properties

    private let defaultImage = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(defaultImage)

        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultImage.heightAnchor.constraint(equalToConstant: 35),
            defaultImage.widthAnchor.constraint(equalToConstant: 35),
            defaultImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.adjusted)
        ])

        nameLabel.textColor = UIColor.black
        nameLabel.font = Device.roundedFont(ofSize: .title2, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        defaultImage.contentMode = UIView.ContentMode.scaleAspectFill
        defaultImage.layer.masksToBounds = false
        defaultImage.layer.cornerRadius = defaultImage.frame.height / 2
        defaultImage.clipsToBounds = true
    }


    func configureCell(name: String) {
        nameLabel.text = name
        defaultImage.image = #imageLiteral(resourceName: "Member")
    }

    func configurePetCell(name: String, image: UIImage) {
        nameLabel.text = name
        defaultImage.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
