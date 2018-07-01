//
//  SearchFilteView.swift
//  Hausa
//
//  Created by Emre Can Bolat on 03.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class SearchFilterAlert: MainAlertController {
    
    private var hausaRow: Int!
    private var englishRow: Int!
    private var bothRow: Int!
    
    private var rowCount = 0
    
    private var currentState = UserConfig.getFilterType()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hausaRow = rowCount
        rowCount += 1
        englishRow = rowCount
        rowCount += 1
        bothRow = rowCount
        rowCount += 1
        
        self.header = ["FILTER", "Select language to search for!"]
        tableView.register(TextCheckCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextCheckCell
        
        let row = indexPath.row
        if row == 0 {
            cell.setTextAndCheck(text: "Hausa", check: .hausa == currentState)
        } else if row == 1 {
            cell.setTextAndCheck(text: "English", check: .english == currentState)
        } else {
            cell.setTextAndCheck(text: "Hausa and English", check: .both == currentState)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row == 0 {
            currentState = .hausa
        } else if row == 1 {
            currentState = .english
        } else {
            currentState = .both
        }
        tableView.reloadData()
    }
    
    @objc override func confirmRequest(sender: UIButton!) {
        UserConfig.setFilterType(type: currentState)
        DispatchQueue.global(qos: .background).async {
            UserConfig.save(true)
        }
        super.confirmRequest(sender: sender)
    }
    
}
