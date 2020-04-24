//
//  JoinGroupVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-10.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class MealsVC: UIViewController {
    
    @IBOutlet weak var mealsTableView: UITableView!
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petnameLabel: UILabel!

    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var mealArray = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
                tableview.delegate = self
                tableview.dataSource = self
               // Create some default meals.
                let Meal1 = Meal(name: "Breakfast", type: "dry", isFed: "true")
                let Meal2 = Meal(name: "Lunch", type: "wet", isFed: "true")
                let Meal3 = Meal(name: "Snack", type: "treat", isFed: "true")
                mealArray.append(Meal1)
                mealArray.append(Meal2)
                mealArray.append(Meal3)

    }

    override func loadView() {
        super.loadView()
        petImage.translatesAutoresizingMaskIntoConstraints = false
        petImage.contentMode = UIView.ContentMode.scaleAspectFill
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70.adjusted),
            petImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            petImage.heightAnchor.constraint(equalToConstant: 100),
            petImage.widthAnchor.constraint(equalToConstant: 100)
        ])
        petImage.layer.masksToBounds = false
        petImage.layer.cornerRadius = petImage.frame.height/2
        petImage.clipsToBounds = true
        self.view.addSubview(petImage)

        petnameLabel.translatesAutoresizingMaskIntoConstraints = false
        petnameLabel.font = Device.roundedFont(ofSize: .largeTitle, weight: .bold)
        petnameLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            petnameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            petnameLabel.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 5.adjusted)
        ])
        self.view.addSubview(petnameLabel)

        
        tableview.register(MealCell.self, forCellReuseIdentifier: "cellId")

        view.addSubview(tableview)

        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: petnameLabel.bottomAnchor, constant: 10.adjusted),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50.adjusted),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        tableview.separatorColor = UIColor.white

    }
    
    @IBAction func addMealButtonPressed(_ sender: Any) {
        let addMealVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMealVC")
        addMealVC?.modalPresentationStyle = .fullScreen
        self.present(addMealVC!, animated: true, completion: nil)
    }
    
    @IBAction func tempLogOut(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to log out of Kibble?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let logoutFailure = UIAlertController(title: "Logout failed. Please try again or check your connection", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
                print(error)
                self.present(logoutFailure, animated: true, completion: nil)
            }
        }))

        logoutFailure.addAction(UIAlertAction(title: "Dimiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }

}

@available(iOS 13.0, *)
extension MealsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = mealArray[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MealCell
        cell.backgroundColor = UIColor.white
        cell.configureCell(isFed: meal.isFed, name: meal.name, type: meal.type)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        destinationUid = messageArray[indexPath.row].senderId
//        destinationName = messageArray[indexPath.row].senderName
//        performSegue(withIdentifier: "FeedToProfile", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.adjusted
    }
}
