//
//  UpdateProfileVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Photos
import Firebase



class UpdateProfileVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(sender:)))
        
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    @IBAction func editBtnPress(_ sender: AnyObject){
        imgViewTapped()
    }
    
    func setUpUI(){
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.clipsToBounds = true
        
        if let profileUrl = CurrentUser.instance.user.profileURL{
            let url = URL(string: profileUrl)

            imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveDownload) { (img, err, cache, url) in
                
            }
        }
        
        
        checkPermission()
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    @objc func imgViewTapped(sender: UITapGestureRecognizer? = nil){
        showAlert()
    }
    
    func showAlert(){
        let alertSheet = UIAlertController(title: "Profile Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showCamera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(libraryAction)
        alertSheet.addAction(cancelAction)
        
        present(alertSheet, animated: true, completion: nil)
    }
    
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = true
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadImg(img: UIImage){
        let userRef = DataService.instance.storageUserRef()
        print("uploadImg1")
        
        let img = img.resized(toWidth: 600)
        guard img != nil else{
            return
        }
        
        if let data = UIImagePNGRepresentation(img!){
        print("uploadImg2")
            let uploadTask = userRef.putData(data, metadata: nil) { (meta, error) in
                guard error == nil else{
                    print("error uploading image -", error)
                    return
                }
                print("uploadImg3")
                guard meta != nil else{
                    print("uploadImg4")
                    return
                }
                
                print("uploadImg5")
                userRef.downloadURL(completion: { (url, error) in
                    print("uploadImg6")
                    guard error == nil else{
                        print("uploadImg7")
                        return
                    }
                    
                    if let url = url{
                        print("uploadImg8")
                        DataService.instance.currentUserDoc.updateData(["profileURL":url.absoluteString])
                    }
                })
                
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                guard snapshot.progress != nil else{
                    return
                }
                
                let percentComplete = round(100 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
                
                print("completed: \(snapshot.progress!.completedUnitCount), Total: \(snapshot.progress!.totalUnitCount)")
                print("the percent complete", percentComplete)
            }
            
            uploadTask.observe(.success) { (snapshot) in
                print("upload complete!")
            }
        }
        
        
    }

}




extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            uploadImg(img: image)
            imgView.image = image
            dismiss(animated: true, completion: nil)
            
        }
    }
}
