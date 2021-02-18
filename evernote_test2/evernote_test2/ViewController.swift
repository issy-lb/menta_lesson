//
//  ViewController.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/18.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        // Do any additional setup after loading the view.
    }

    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        {
            return true
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.row == 3 || indexPath.row == 6{
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let textField = cell.viewWithTag(1) as! UITextField
        textField.text = "Item \(indexPath.row)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
          return true
      }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
          // TODO: 入れ替え時の処理を実装する（データ制御など）
      }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
          return false
    }
    

}

