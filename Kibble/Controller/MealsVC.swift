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

    override func viewDidLoad() {
        super.viewDidLoad()
        mealTableView.delegate = self
        mealTableView.dataSource = self
        mealTableView.rowHeight = 120

    }
    

}

extension MealsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell") as? MealCell else { return UITableViewCell() }
        
        return cell
    }
    
    

}
