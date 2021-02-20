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
    
    var resource = TableResourceModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragDelegate = self
               tableView.dropDelegate = self
               tableView.dragInteractionEnabled = true
        
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
        return resource.prefectureNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
//        cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
//        cell.textLabel?.text = resource.prefectureNames[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let textField = cell.viewWithTag(1) as! UITextView
//        textField.isEditable = false
        textField.text = resource.prefectureNames[indexPath.row]
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
