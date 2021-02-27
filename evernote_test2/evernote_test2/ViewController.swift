//
//  ViewController.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/18.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, InputViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!

    
    
    
    
    
    var note = Note(contents:  ["1","2","3","","5"])
    
    var resource = TableResourceModel()
    
    //    inputViewを読み込む
    private lazy var bottomInputView:InputView = {
        let view = InputView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    func sendTapped(text: String) {
        resource.prefectureNames.append(text)
        tableView.reloadData()
        scrollToBottom()
    }
    override var inputAccessoryView: UIView?{
        return bottomInputView
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    
            
            
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragDelegate = self
               tableView.dropDelegate = self
               tableView.dragInteractionEnabled = true
        tableView.keyboardDismissMode = .interactive
        
        // Do any additional setup after loading the view.
        
        
        //    キーボード表示・非表示のメソッド
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
        
//        終了する直前
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    @objc func didEnterBackground(_ notification:Notification){
        print("アプリ終了")
    }
    
//    アプリ終了時の処理
    @objc func keyboardWillShow(_ notification:Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollToBottom()
        }
    }
    @objc func keyboardWillHide(_ notification:Notification){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
    }
    
 
    
    func scrollToBottom(){
        let rowNum = tableView.numberOfRows(inSection: 0)
        if rowNum != 0 {
            tableView.scrollToRow(at: IndexPath(row: rowNum-1, section: 0), at: .bottom, animated: true)
        }
    }


    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        {
            return true
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resource.prefectureNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        cell.initialize(resource.prefectureNames[indexPath.row]){
            tableView.performBatchUpdates(nil, completion: nil)
            self.resource.update(sourcePath: indexPath.row, text: cell.noteView.text)
        }
//        cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
//        cell.textLabel?.text = resource.prefectureNames[indexPath.row]
//        cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let textField = cell.viewWithTag(1) as! UITextView
//        textField.isEditable = false
//        textField.text = resource.prefectureNames[indexPath.row]
        return cell
    }
    

    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            resource.prefectureNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    


}

extension ViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        tableView.visibleCells.forEach{cell in
            let textField = cell.viewWithTag(1) as! UITextView
            textField.isEditable = false
        }
        // Todo: implementation
        return [resource.dragItem(for: indexPath)]
    }
}

extension ViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first,
            let destinationIndexPath = coordinator.destinationIndexPath,
            let sourceIndexPath = item.sourceIndexPath else { return }

        tableView.performBatchUpdates({ [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resource.moveItem(sourcePath: sourceIndexPath.row, destinationPath: destinationIndexPath.row)
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            }, completion: nil)
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        tableView.visibleCells.forEach{cell in
            let textField = cell.viewWithTag(1) as! UITextView
            textField.isEditable = true
        }
    }
}
