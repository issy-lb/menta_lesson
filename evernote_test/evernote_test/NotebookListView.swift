//
//  NotebookListView.swift
//  evernote_test
//
//  Created by 石田洋輔 on 2021/02/14.
//

import UIKit
import EvernoteSDK

class NotebookListView: UIViewController {
    let CONSUMER_KEY    = "yosuke-8489"
    let CONSUMER_SECRET = "362e676ef94398b6"

    @IBOutlet weak var notebookList: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotebooks()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //    ノーブック一覧を表示する操作
        func getNotebooks(){
            ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
    optionalHost: ENSessionHostSandbox)
            let session = ENSession.shared
            if session.isAuthenticated {
                session.authenticate(with: self, preferRegistration: false, completion: { error in
                    if error == nil {
                        session.listNotebooks(completion: {
                        notebooks,error in
                            if error == nil{
                                notebooks?.forEach{ notebook in
                                    self.notebookList.text += "\(notebook.name!),"
                                }
                            }
                        })
                    } else {
                        print("Authentication error: \(error)")
                    }
                })
            } else {
                session.authenticate(with: self, preferRegistration: false, completion: { error in
                    if error == nil {
                        self.getNotebooks()
                    } else {
                        print("Authentication error: \(error)")
                    }
                })
            }
        }
}
