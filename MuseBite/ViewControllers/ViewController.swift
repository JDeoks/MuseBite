//
//  ViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    func initUI() {
        //postTableView
        postTableView.dataSource = self
        postTableView.delegate = self
        let postTableViewCell = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(postTableViewCell, forCellReuseIdentifier: "PostTableViewCell")
        // 네비게이션
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        return cell
    }
    
}
