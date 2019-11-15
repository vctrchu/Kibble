//
//  JoinGroupVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-10.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit

class MealsVC: UIViewController {
    
    @IBOutlet weak var mealTableView: UITableView!
    

    var mealArray = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.delegate = self
        mealTableView.dataSource = self
        mealTableView.rowHeight = 120
        
        let Meal1 = Meal(title: "Breakfast", isFed: true, description: "Half Can.")
        let Meal2 = Meal(title: "Lunch", isFed: false, description: "Half Can")
        let Meal3 = Meal(title: "Dinner", isFed: false, description: "Full Can")
        mealArray.append(Meal1)
        mealArray.append(Meal2)
        mealArray.append(Meal3)

    }
    

}

extension MealsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealCell else { return UITableViewCell() }
        
        cell.mealTitle?.text = mealArray[indexPath.row].title
        cell.isFedImage.image = UIImage(named: String(mealArray[indexPath.row].isFed))
        
        return cell
    }
    
    

}
