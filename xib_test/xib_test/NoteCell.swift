//
//  NoteCell.swift
//  NoteView
//
//  Created by Kakeru Fukuda on 2021/02/20.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var noteView: UITextView!
    private var onChanged: (() -> Void)!
    
    func initialize(_ text: String, changed: @escaping () -> Void) {
        noteView.text = text
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
