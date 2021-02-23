//
//  InputView.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/23.
//

import Foundation
import UIKit

class InputView:UIView{
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var photoBtn: UIBarButtonItem!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextView!
    
    var delegate:InputViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFromXib()
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFromXib(){
        let nib = UINib.init(nibName: "InputView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(view)
    }
    
    @IBAction func onCamera(_ sender: Any) {
    }
    @IBAction func onPhoto(_ sender: Any) {
    }
    @IBAction func onSend(_ sender: Any) {
        delegate.sendTapped(text: inputTextField.text!)
        inputTextField.text = ""
    }
    override var intrinsicContentSize: CGSize{
        return .zero
    }
}

protocol InputViewDelegate:class {
    func sendTapped(text:String)
}
