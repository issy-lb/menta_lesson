//
//  ViewController.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/18.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputText: UITextView!
    
    
    
    
    var note = Note(contents:  ["1","2","3","","5"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSend(_ sender: Any) {
        note.contents.append(inputText.text!)
        inputText.text = ""
        tableView.reloadData()
    }
    
    

    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        {
            return true
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return note.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if note.contents[indexPath.row] as! String == ""{
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let textField = cell.viewWithTag(1) as! UITextView
//            textField.delegate = self
//            textField.accessibilityIdentifier = indexPath.description
            textField.text = note.contents[indexPath.row] as! String
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

//extension ViewController:UITextViewDelegate{
//    func
//    textFieldDidEndEditing(_ textField: UITextField) {
//        textField.accessibilityIdentifier
//        print("編集完了")
//    }
//}
