//
//  NoteCell.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/23.
//

import Foundation
import UIKit
class NoteCell: UITableViewCell {
    private var onChanged: (() -> Void)!
    @IBOutlet weak var noteView: UITextView!
    
    func initialize(_ text: String, changed: @escaping () -> Void) {
        noteView.text = text
        noteView.isEditable = true
        onChanged = changed
        noteView.delegate = self
    }
}

extension NoteCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.onChanged()
        }
        return true
    }
}
