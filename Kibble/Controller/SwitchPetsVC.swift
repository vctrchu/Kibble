//
//  SwitchPetsVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-07.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

class SwitchPetsVC: UITableViewController {

    // MARK: - Properties
    private var pets = [Pet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MemberCell.self, forCellReuseIdentifier: "cellId")
        setup()
    }

    override func loadView() {
        super.loadView()
        tableView.tableFooterView = UIView()
        tableView.alpha = 0
    }

    func setup() {

        // TODO: - Add loading indicator... currently settings page pauses before this is loaded..

        DataService.instance.retrieveAllPetsForUser(withUid: Auth.auth().currentUser!.uid) { (allPetIds) in
            let group = DispatchGroup()
            for (key, _) in allPetIds {
                group.enter()
                DataService.instance.retrievePet(key) { (returnedPet) in
                    if let pet = returnedPet {
                        self.pets.append(pet)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                
                print("All requests finished")
                print(self.pets.count)
                self.tableView.reloadData()
                self.tableView.fadeIn(duration: 0.25, delay: 0, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pet = pets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MemberCell

        var petImage = UIImage()
        if let imageUrlString = pet.photoUrl {
            let imageUrl = URL(string: imageUrlString)!
            let imageData = try! Data(contentsOf: imageUrl)
            let image = UIImage(data: imageData)
            petImage = image!
        } else {
            petImage = #imageLiteral(resourceName: "dog")
        }
        cell.configurePetCell(name: pet.name, image: petImage)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
