//
//  ViewController.swift
//  camera_test
//
//  Created by 石田洋輔 on 2021/02/25.


import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBAction func launchCamera(_ sender: Any) {
        let camera = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(camera){
            let picker = UIImagePickerController()
            picker.sourceType = camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageView.image = image
        
        
        self.dismiss(animated: true)
        
        
    }
    @IBAction func onPhoto(_ sender: Any) {
        let photoLibrary = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(photoLibrary){
            let picker = UIImagePickerController()
                picker.modalPresentationStyle = UIModalPresentationStyle.popover
                picker.delegate = self
            if let popover = picker.popoverPresentationController {
                    popover.sourceView = self.view
                    popover.sourceRect = photoButton.frame // ポップオーバーの表示元となるエリア
                    popover.permittedArrowDirections = UIPopoverArrowDirection.any
                }
                self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
