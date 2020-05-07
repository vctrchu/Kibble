//
//  JoinGroupVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-10.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import Pastel
import SwipeCellKit

@available(iOS 13.0, *)
class MealsVC: UIViewController {
    
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet var pastelView: PastelView!
    private let refreshControl = UIRefreshControl()

    let petImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        image.image = #imageLiteral(resourceName: "dog")
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let petnameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = Device.roundedFont(ofSize: .largeTitle, weight: .heavy)
        label.textAlignment = .center
        return label
    }()

    let settingsButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        return button
    }()

    let membersButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setImage(#imageLiteral(resourceName: "membersButton"), for: .normal)
        return button
    }()

    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var mealArray = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 200
        retrieveMealData()
    }

    override func loadView() {
        super.loadView()
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        addMealButton.addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
        tableView.register(MealCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorColor = UIColor.clear
        tableView.addSubview(refreshControl)
        self.view.addSubview(tableView)
        self.view.addSubview(addMealButton)
        refreshControl.addTarget(self, action: #selector(mealDataRefresh), for: .valueChanged)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }

    func retrieveMealData() {
//        DataService.instance.retrieveUserFullName(withUid: LocalStorage.instance.currentUser.id) { (name) in
//            self.petnameLabel.text = name
//        }
        guard let uid = Auth.auth().currentUser?.uid else { fatalError("Current user uid is nil") }
        DataService.instance.retrieveCurrentPet(forUid: uid) { (petId) in
            DataService.instance.retrieveAllPetMeals(forPetId: petId) { (retreivedMeals) in
                self.mealArray = retreivedMeals
                LocalStorage.instance.currentPetMeals = retreivedMeals
                print(self.mealArray.count)
                UIView.transition(with: self.tableView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.tableView.reloadData() })
                self.refreshControl.endRefreshing()
            }
        }
    }

    func refreshLocalData() {
        LocalStorage.instance.currentPetMeals = mealArray
        print(self.mealArray.count)
        UIView.transition(with: self.tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
        self.refreshControl.endRefreshing()
    }

    @objc func mealDataRefresh() {
        retrieveMealData()
    }

    @objc func addMealButtonPressed() {
        let addMealVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        addMealVC.delegate = self
        self.present(addMealVC, animated: true, completion: nil)
    }

    @objc func settingsButtonPressed() {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }

}

@available(iOS 13.0, *)
extension MealsVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = mealArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MealCell
        cell.delegate = self
        cell.configureCell(isFed: meal.isFed, name: meal.name, type: meal.type)
        return cell
    }

    // Edit Meal
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = mealArray[indexPath.row]
        let editMealVC = self.storyboard?.instantiateViewController(identifier: "EditMealVC") as! EditMealVC
        editMealVC.delegate = self
        // this is not nice we should create a method to set these values...
        editMealVC.mealName = meal.name
        editMealVC.reminderTime = meal.notification
        editMealVC.mealType = meal.type
        //editMealVC.setup(name: meal.name, type: meal.type, notification: meal.notification!)
        self.present(editMealVC, animated: true, completion: nil)
    }

    // Swipe Cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let doneAction = SwipeAction(style: .destructive, title: "Done") { action, indexPath in
                let petId = LocalStorage.instance.currentUser.currentPet
                let mealName = self.mealArray[indexPath.row].name
                DataService.instance.updatePetMeals(withPetId: petId, withMealName: mealName, andMealData: ["isFed":"true"]) {
                    self.retrieveMealData()
                }
            }
            let cell = tableView.cellForRow(at: indexPath)!
            doneAction.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.9294117647, blue: 0.4745098039, alpha: 1)
            return [doneAction]
        } else if orientation == .right {
            let undoAction = SwipeAction(style: .destructive, title: "Undo") { action, indexPath in
                let petId = LocalStorage.instance.currentUser.currentPet
                let mealName = self.mealArray[indexPath.row].name
                DataService.instance.updatePetMeals(withPetId: petId, withMealName: mealName, andMealData: ["isFed":"false"]) {
                    self.retrieveMealData()
                }
            }
            undoAction.backgroundColor = #colorLiteral(red: 1, green: 0.3400763623, blue: 0.3629676378, alpha: 1)
            return [undoAction]
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.transitionStyle = .border
        return options
    }

    //MARK: - Table View Header Set Up

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(settingsButton)
        headerView.addSubview(membersButton)
        headerView.addSubview(petImage)
        headerView.addSubview(petnameLabel)

        DataService.instance.retrievePet(LocalStorage.instance.currentUser.currentPet) { (pet) in
            self.petnameLabel.text = pet.name
            if let imageUrlString = pet.photoUrl {
                let imageUrl = URL(string: imageUrlString)!
                let imageData = try! Data(contentsOf: imageUrl)
                let image = UIImage(data: imageData)
                self.petImage.image = image
            } else {
                self.petImage.image = #imageLiteral(resourceName: "dog")
            }
        }

        petImage.translatesAutoresizingMaskIntoConstraints = false
        let topPetImage = petImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20.adjusted)
        let centerPetImage = petImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        let widthPetImage = petImage.widthAnchor.constraint(equalToConstant: 90)
        let heightPetImage = petImage.heightAnchor.constraint(equalToConstant: 90)
        headerView.addConstraints([topPetImage, centerPetImage, widthPetImage, heightPetImage])

        petnameLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerXPetLabel = petnameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        let topPetLabel = petnameLabel.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 5.adjusted)
        headerView.addConstraints([centerXPetLabel, topPetLabel])

        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let centerXSetting = settingsButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        let bottomSetting = settingsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        headerView.addConstraints([centerXSetting, bottomSetting])

        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension MealsVC: AddMealDelegate {
    func refreshTableView() {
        retrieveMealData()
    }
}
