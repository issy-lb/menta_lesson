import UIKit
import EvernoteSDK

class ViewController: UIViewController {
    let CONSUMER_KEY    = "yosuke-8489"
    let CONSUMER_SECRET = "362e676ef94398b6"
    
    
    @IBOutlet weak var NoteTitle: UITextField!
    @IBOutlet weak var NoteContent: UITextView!
    
    
    @IBAction func postNote(_ sender: Any) {
        postTestNote(title: NoteTitle.text!, content: NoteContent.text!)
        NoteTitle.text = ""
        NoteContent.text = ""
    }
    @IBAction func onTime(_ sender: Any) {
        timestamp(text: NoteContent)
    }

//    スワイプ
    @IBAction func swipeRight(_ sender: Any) {
        postTestNote(title: NoteTitle.text!, content: NoteContent.text!)
        NoteTitle.text = ""
        NoteContent.text = ""
    }
    
    
    func timestamp(text:UITextView){
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = dateFormatter.string(from: dt)
        text.text! += dateString
    }
    
    private func postTestNote(title:String,content:String) {
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
optionalHost: ENSessionHostSandbox)
        
        let session = ENSession.shared
        if session.isAuthenticated {
            let note = ENNote()
            note.title = title
            note.content = ENNoteContent(string: content)
            session.upload(note, notebook: nil, completion: { noteRef, error in
                if error == nil {
                    print("Note Upload OK")
                } else {
                    print("Upload note error: \(error)")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
