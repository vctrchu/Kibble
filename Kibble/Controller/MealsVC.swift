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

@available(iOS 13.0, *)
class MealsVC: UIViewController {
    
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet var pastelView: PastelView!
    private let refreshControl = UIRefreshControl()

    let petImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image.image = #imageLiteral(resourceName: "cat")
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let petnameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = Device.roundedFont(ofSize: .largeTitle, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        let tableViewPastelView = PastelView()
        tableViewPastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)])
        tv.backgroundView = tableViewPastelView
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var mealArray = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 250.adjusted
        //retrieveMealData()
    }

    override func loadView() {
        super.loadView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

//        self.pastelView.addSubview(tableView)
//        self.pastelView.addSubview(addMealButton)
//        tableView.register(MealCell.self, forCellReuseIdentifier: "cellId")
//        tableView.separatorColor = UIColor.clear
//        tableView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(mealDataRefresh), for: .valueChanged)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
//        ])
//        addMealButton.addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        let tableViewPastelView = PastelView()
        tableView.backgroundView = tableViewPastelView
        tableViewPastelView.startPastelPoint = .bottomLeft
        tableViewPastelView.endPastelPoint = .topRight
        tableViewPastelView.animationDuration = 3
        tableViewPastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1),#colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.9019607843, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1)])
        tableViewPastelView.startAnimation()
    }

    func retrieveMealData() {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError("Current user uid is nil") }
        DataService.instance.retrieveCurrentPet(forUid: uid) { (petId) in
            DataService.instance.retrieveAllPetMeals(forPetId: petId) { (retreivedMeals) in
                self.mealArray = retreivedMeals
                LocalStorage.instance.currentPetMeals = retreivedMeals
                print(self.mealArray.count)
                UIView.transition(with: self.tableView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { self.tableView.reloadData() })
                self.refreshControl.endRefreshing()
            }
        }
    }

    @objc func mealDataRefresh() {
        retrieveMealData()
    }

    @objc func addMealButtonPressed() {
        let addMealVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        addMealVC.delegate = self
        self.present(addMealVC, animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(self.petImage)
        headerView.addSubview(self.petnameLabel)
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 70.adjusted),
            petImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            petImage.heightAnchor.constraint(equalToConstant: 100),
            petImage.widthAnchor.constraint(equalToConstant: 100)
        ])

        petnameLabel.translatesAutoresizingMaskIntoConstraints = false
        let currentPet = LocalStorage.instance.currentUser.currentPet
        petnameLabel.text = LocalStorage.instance.petIds[currentPet]?.name
        NSLayoutConstraint.activate([
            petnameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            petnameLabel.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 5.adjusted)
        ])
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = mealArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MealCell
        cell.backgroundColor = UIColor.clear
        cell.configureCell(isFed: meal.isFed, name: meal.name, type: meal.type)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MealsVC: AddMealDelegate {
    func refreshTableView() {
        retrieveMealData()
    }
}
