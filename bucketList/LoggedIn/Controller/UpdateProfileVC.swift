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
import FirebaseStorage



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
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.clipsToBounds = true
        if let profileUrl = CurrentUser.instance.user.profileURL{
            if let url = URL(string: profileUrl){
                imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveDownload) { (img, err, cache, url) in
                }
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
        let userStorageRef = DataService.instance.storageUserRef()
        uploadThumb(img: img)
        let img = img.resized(toWidth: 600)
        guard img != nil else{
            return
        }
        
        if let data = UIImagePNGRepresentation(img!){
            let timeInterval = Date().timeIntervalSince1970
            let profileRef = userStorageRef.child("profiles").child("profile_\(timeInterval).png")
            let myMeta = StorageMetadata(dictionary: ["contentType": "image/"])
            let uploadTask = profileRef.putData(data, metadata: myMeta) { (meta, error) in
                guard error == nil else{
                    print("error uploading image -", error)
                    return
                }
                guard meta != nil else{
                    return
                }
                profileRef.downloadURL(completion: { (url, error) in
                    guard error == nil else{
                        print("uploadImg7 \(error)")
                        return
                    }
                    
                    if let url = url{
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
    
    func uploadThumb(img: UIImage){
        let userStorageRef = DataService.instance.storageUserRef()

        let img = img.resized(toWidth: 200)
        guard img != nil else{
            return
        }
        
        if let data = UIImagePNGRepresentation(img!){
            let timeInterval = Date().timeIntervalSince1970
            let profileRef = userStorageRef.child("profiles").child("thumb_profile_\(timeInterval).png")
            let myMeta = StorageMetadata(dictionary: ["contentType": "image/"])
            
            _ = profileRef.putData(data, metadata: myMeta) { (meta, error) in
                guard error == nil else{
                    print("error uploading image -", error!)
                    return
                }
                guard meta != nil else{
                    return
                }
                profileRef.downloadURL(completion: { (url, error) in
                    guard error == nil else{
                        print("uploadImg7 \(error)")
                        return
                    }
                    
                    if let url = url{
                        DataService.instance.currentUserDoc.updateData(["thumbProfileURL":url.absoluteString])
                    }
                })
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
