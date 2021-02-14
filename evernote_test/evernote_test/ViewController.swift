import UIKit
import EvernoteSDK

class ViewController: UIViewController {
    let CONSUMER_KEY    = "yosuke-8489"
    let CONSUMER_SECRET = "362e676ef94398b6"
    var selectedNotebook:ENNotebook?
    
    
    @IBOutlet weak var NoteTitle: UITextField!
    @IBOutlet weak var NoteContent: UITextView!
    @IBOutlet var testView: UIView!
    @IBOutlet weak var selectNotebook: UIButton!
    
    
//    触覚フィードバック
    private let feedbackGenerator: Any? = {
            if #available(iOS 10.0, *) {
                let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                return generator
            } else {
                return nil
            }
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotebook()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwiped(_:)))
        swipe.direction = .left
        testView.addGestureRecognizer(swipe)

    }
    
    //    タイムスタンプを押す操作
        @IBAction func onTime(_ sender: Any) {
            timestamp(text: NoteContent)
        }
    
    
    
//    ノートを投稿する操作
    @IBAction func postNote(_ sender: Any) {
        postTestNote(title: NoteTitle.text!, content: NoteContent.text!)
        NoteTitle.text = ""
        NoteContent.text = ""
    }
//    スワイプの時の操作
    @objc func onSwiped(_ sender:UISwipeGestureRecognizer){
        postTestNote(title: NoteTitle.text!, content: NoteContent.text!)
        NoteTitle.text = ""
        NoteContent.text = ""
//        触覚フィードバック
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
                    generator.impactOccurred()
                }
        print("スワイプ成功")
    }
    
    
    
//    タイムスタンプを押す関数
    func timestamp(text:UITextView){
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = dateFormatter.string(from: dt)
        text.text! += dateString
    }
    
//    タグを表示する操作
    @IBAction func onGettag(_ sender: Any) {
        getTag()
    }
    
    
//    ノートを投稿する関数
    private func postTestNote(title:String,content:String) {
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
optionalHost: ENSessionHostSandbox)
        
        let session = ENSession.shared
        if session.isAuthenticated {
            let note = ENNote()
            session.findNotes(with:nil, in: nil, orScope: .appNotebook, sortOrder: .recentlyCreated, maxResults: 10, completion: {notes,error in
                notes?.forEach{note in
                    print(note.title ?? "nilでした")
                }
            })
            var notebook:ENNotebook?
            session.listNotebooks(completion: {notebooks,error in
                if error == nil{
//                    1つ目のノートブックを取ってくる
                notebook = notebooks?[0]
                    print(notebook?.name ?? "nil")
                    note.title = title
                    note.content = ENNoteContent(string: content)
//                    1つ目のノートブックに投稿する
                    session.upload(note, notebook: self.selectedNotebook, completion: { noteRef, error in
                        if error == nil {
                            print("Note Upload OK")
                        } else {
                            print("Upload note error: \(error)")
                        }
                    })
                }
            })
        } else {
            session.authenticate(with: self, preferRegistration: false, completion: { error in
                if error == nil {
                    self.postTestNote(title: title, content: content)
                } else {
                    print("Authentication error: \(error)")
                }
            })
        }
    }
//   ノートブック設定
    func setNotebook(){
        if selectedNotebook == nil{
            ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
    optionalHost: ENSessionHostSandbox)
            
            let session = ENSession.shared
            if session.isAuthenticated {
                session.authenticate(with: self, preferRegistration: false, completion: { error in
                    if error == nil {
                        session.listNotebooks(completion: {
                        notebooks,error in
                            if error == nil && (notebooks != nil){
                                self.selectedNotebook = notebooks![0]
                                self.selectNotebook.setTitle(self.selectedNotebook?.name!, for: .normal)

                                }
                            }
                        )
                    } else {
                        print("Authentication error: \(error)")
                    }
                })
        }else {
            session.authenticate(with: self, preferRegistration: false, completion: { error in
                if error == nil {
                } else {
                    print("Authentication error: \(error)")
                }
            })
        }
        }else{
            self.selectNotebook.setTitle(self.selectedNotebook?.name!, for: .normal)
        }
    }
    
//    タグ取得関数
    func getTag(){
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
optionalHost: ENSessionHostSandbox)
        let session = ENSession.shared
        if session.isAuthenticated {
            session.authenticate(with: self, preferRegistration: false, completion: { error in
                if error == nil {
                    let store = session.primaryNoteStore()
                    store?.listTags(completion: {tags,error in
                        tags?.forEach{tag in
                            print(tag.name ?? "nil")
                        }
                    })
                } else {
                    print("Authentication error: \(error)")
                }
            })
    }else {
        session.authenticate(with: self, preferRegistration: false, completion: { error in
            if error == nil {
            } else {
                print("Authentication error: \(error)")
            }
        })
    }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
