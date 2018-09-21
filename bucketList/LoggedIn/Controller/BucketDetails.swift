//
//  BucketDetails.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class BucketDetails: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String] = [String]()
    var bucketItem: BucketItem?
    var spaceBetweenCells: CGFloat = 10
    var selectedImgCell: DetailImgCell?
    var imagePicker: UIImagePickerController!
    
    var sizingNibNew = Bundle.main.loadNibNamed("ItemDataCell", owner: ItemDataCell.self, options: nil) as? NSArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        hero.isEnabled = true
        hero.modalAnimationType = .fade
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let nib = UINib(nibName: "ItemDataCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ItemDataCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        if let item = bucketItem{
            images = item.imgs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getImages()
        if let item = bucketItem{
            self.navigationItem.title = item.title
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getImages(){
        if let item = bucketItem, let id = item.id{
            DataService.instance.bucketListRef.document(id).collection("images").getDocuments{(snapshot, error) in
                guard error == nil && snapshot != nil else{
                    return
                }
                for snap in snapshot!.documents{
                    let snapDoc = snap.data()
                    if let url = snapDoc["url"] as? String{
                        self.images.append(url)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }

    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
    }
    
    func uploadImage(image: UIImage){
        let usersStorageRef = DataService.instance.storageUserRef()
        guard bucketItem != nil && bucketItem?.id != nil else{
            return
        }
        
        let img = image.resized(toWidth: 800)
        guard img != nil else{
            return
        }
        
        if let data = UIImagePNGRepresentation(img!){
            let meta = StorageMetadata(dictionary: ["contentType": "image/"])
            let date = Date().timeIntervalSince1970
            let imageRef = usersStorageRef.child("bucketItems").child(bucketItem!.id!).child("\(date).png")
            let uploadTask = imageRef.putData(data, metadata: meta) { (meta, error) in
                guard error == nil else{
                    print("error uploading")
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    guard error == nil else {
                        print("downloadURL error", error?.localizedDescription)
                        return
                    }
                    if let url = url{
                        DataService.instance.bucketListRef.document(self.bucketItem!.id!).collection("images").addDocument(data: ["url": url.absoluteString, "added": FieldValue.serverTimestamp()])
                    }
                })
            }
        }
    }
    
    func showAlert(){
        let actionSheet = UIAlertController(title: "Bucket Image", message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showCamera()
        }
        let showPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(showPhotoLibrary)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func showPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension BucketDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0, let bucketItem = bucketItem{
            print("cellForItemAt1")
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDataCell", for: indexPath) as? ItemDataCell{
                cell.configure(item: bucketItem)
                return cell
            }
        }
        if indexPath.row == 1{
            print("cellForItemAt2")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCamera", for: indexPath)
            let lightGrayView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            lightGrayView.backgroundColor = UIColor().extraLightGrey
            cell.selectedBackgroundView = lightGrayView
            return cell
        }
        if indexPath.row > 0{
            print("cellForItemA3")
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailImgCell{
                cell.configure(imgUrl: images[indexPath.row - 2])
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.hero.navigationAnimationType = .fade
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 1{
            showAlert()
        } else{
            if let vc = storyboard.instantiateViewController(withIdentifier: "LargeImageVC") as? LargeImageVC{
                vc.imgURLString = images[indexPath.row - 2]
                if let cell = collectionView.cellForItem(at: indexPath) as? DetailImgCell{
                    selectedImgCell?.hero.id = nil
                    selectedImgCell = cell
                    cell.hero.id = "toLargeImg"
                    if let img = cell.imgView.image{
                        vc.newImg = img
                    }
                }
                vc.hero.isEnabled = true
                self.hero.modalAnimationType = .none
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnPress(_ sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "LargeImageVC") as? LargeImageVC{
            vc.imgURLString = images[1]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            let width = self.view.frame.width - CGFloat(20)// / 3.0
            
            if let item = bucketItem{
                let requiredWidth = collectionView.bounds.size.width
                let targetSize = CGSize(width: requiredWidth, height: 0)
                let newCell: ItemDataCell = .fromNib()
                newCell.configure(item: item)
                let layoutAttributes = collectionViewLayout.layoutAttributesForItem(at: indexPath)
                layoutAttributes?.frame.size = targetSize
                let adequateSize = newCell.preferredLayoutAttributesFitting(layoutAttributes!)
                let inset = collectionView.contentInset.right + collectionView.contentInset.left
                
                return CGSize(width: self.collectionView.bounds.width - inset, height: adequateSize.frame.height)
            }
            return CGSize(width: width, height: width)
        }
        
        let inset = collectionView.contentInset.right + collectionView.contentInset.left
        let width = collectionView.frame.width / 2 - spaceBetweenCells / 2 - inset / 2 - 1
        
        if indexPath.row == 1{
            return CGSize(width: collectionView.frame.width - inset - 20, height: 50)
        }
        return CGSize(width: width, height: width)
    }
}


extension BucketDetails: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            uploadImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}















