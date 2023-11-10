//
//  RecordListViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 11/5/23.
//

import UIKit

class RecordListViewController: UIViewController {
    
    var currentCellindex = -1
    
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
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 인덱스 오류
        print(indexPath)
        
        // 선택된 셀의 인덱스를 기억
        let previousCellIndex = currentCellindex
        
        // 현재 선택된 셀의 인덱스 갱신
        currentCellindex = indexPath.row
        print(previousCellIndex, currentCellindex)
        // 이전에 선택된 셀과 현재 선택된 셀이 다른 경우에만 갱신
        if previousCellIndex != currentCellindex {
            if 0 <= previousCellIndex && previousCellIndex < 10 {
                let lastTouchCell = recordTableView.cellForRow(at: IndexPath(row: 0, section: previousCellIndex)) as! RecordTableViewCell
                lastTouchCell.playStackView.isHidden.toggle()
            }
            
            let cell = recordTableView.cellForRow(at: indexPath) as? RecordTableViewCell
            cell?.playStackView.isHidden.toggle()
        }
        
        // 선택한 셀만 갱신
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
