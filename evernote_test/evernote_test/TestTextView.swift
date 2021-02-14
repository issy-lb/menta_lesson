//
//  TestTextView.swift
//  evernote_test
//
//  Created by 石田洋輔 on 2021/02/14.
//

import UIKit
import EvernoteSDK
import HTMLEntities

class TestTextView: UIViewController {
    let CONSUMER_KEY    = "yosuke-8489"
    let CONSUMER_SECRET = "362e676ef94398b6"


    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var testImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: "Start of text")



        // wrap the attachment in its own attributed string so we can append it
        
        fullString.append(NSAttributedString(string: "End of text"))
        // Do any additional setup after loading the view.
        textField.attributedText = fullString

    }
    
    @IBAction func onAdd(_ sender: Any) {
        // create our NSTextAttachment
//        let Field = NSMutableAttributedString(attributedString: textField.attributedText)
//        let image1Attachment = NSTextAttachment()
//        image1Attachment.image = testImage.image
//        let image1String = NSAttributedString(attachment: image1Attachment)
//        Field.append(image1String)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
//        fullString.append(image1String)
//        textField.attributedText = Field
//            .append image1String
        
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        let htmlData = try! textField.attributedText.data(from: NSRange(location: 0, length: textField.attributedText.length),
                                                  documentAttributes: documentAttributes)
        let html = String(data: htmlData, encoding: .utf8)
        let escaped = html?.htmlEscape()
        print(html ?? "Empty")
        print(escaped ?? "no escaped")
        let enml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note><en-todo/>An item that I haven't completed yet.</en-note>"
        postTestNote(content:enml)
        
    }
    
    @IBAction func onSend(_ sender: Any) {
        
    }
    
    
    //    ノートを投稿する関数
        private func postTestNote(content:String) {
            ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
    optionalHost: ENSessionHostSandbox)
            
            let session = ENSession.shared
            if session.isAuthenticated {
                let note = ENNote()
                        note.title = "画像テスト！"
                note.content = ENNoteContent(enml: content)
    //                    1つ目のノートブックに投稿する
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
                        self.postTestNote(content: content)
                    } else {
                        print("Authentication error: \(error)")
                    }
                })
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
