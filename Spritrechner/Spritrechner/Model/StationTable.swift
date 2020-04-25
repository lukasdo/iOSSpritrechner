//
//  StationTable.swift
//  Spritrechner
//
//  Created by Lukas on 14.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import UIKit

final class StationTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var maxHeight: CGFloat = (UIScreen.main.bounds.size.height)/4
    
    var tableCells:[String]?
    static let singleton = StationTable()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        return cell
    }
    
    override func reloadData() {
         super.reloadData()
         self.invalidateIntrinsicContentSize()
         self.layoutIfNeeded()
       }
       
       override var intrinsicContentSize: CGSize {
         let height = min(contentSize.height, maxHeight)
         return CGSize(width: contentSize.width, height: height)
       }
}
