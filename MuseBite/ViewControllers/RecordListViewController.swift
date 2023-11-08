//
//  RecordListViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 11/5/23.
//

import UIKit

class RecordListViewController: UIViewController {
    
    
    @IBOutlet var recordTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        // recordTableView
        recordTableView.delegate = self
        recordTableView.dataSource = self
        let recordTableViewCell = UINib(nibName: "RecordTableViewCell", bundle: nil)
        recordTableView.register(recordTableViewCell, forCellReuseIdentifier:"RecordTableViewCell")
        recordTableView.rowHeight = UITableView.automaticDimension
    }

}

extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell") as! RecordTableViewCell
//        if indexPath.row != 1{
//            cell.playStackView.isHidden = true
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = recordTableView.cellForRow(at: indexPath) as! RecordTableViewCell
        cell.playStackView.isHidden.toggle()
        
    }
}
