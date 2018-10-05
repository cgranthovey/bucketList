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
import MapKit

class URLOrImage{
    var urlString: String?
    var image: String?
}

class BucketDetails: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [Any] = [Any]()
    var bucketItem: BucketItem?
    var spaceBetweenCells: CGFloat = 10
    var selectedImgCell: DetailImgCell?
    var imagePicker: UIImagePickerController!
    
    var nonImgCells = [0, 1, 2, 3, 4]
    
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
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        
        if let item = bucketItem{
            images = item.imgs
            if images.count > 0{
                nonImgCells.removeLast()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getImages()
        if let item = bucketItem{
            self.navigationItem.title = item.title
            print("bucketItem ID", item.id!)
        }
//        let cameraBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "camera-1"), landscapeImagePhone: #imageLiteral(resourceName: "camera-1"), style: .plain, target: self, action: #selector(BucketDetails.showAlert))
//        navigationItem.rightBarButtonItems = [cameraBtn]

        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getImages(){
        if let item = bucketItem, let id = item.id{
            DataService.instance.bucketListRef.document(id).collection("images").order(by: "added", descending: true).getDocuments{(snapshot, error) in
                guard error == nil && snapshot != nil else{
                    return
                }
                for snap in snapshot!.documents{
                    let snapDoc = snap.data()
                    if let url = snapDoc["url"] as? String{
                        self.images.append(url)
                    }
                }
                if self.images.count > 0{
                    self.nonImgCells.removeLast()
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    var cellUploading: DetailImgCell?
    
    func uploadImage(image: UIImage){
        let usersStorageRef = DataService.instance.storageUserRef()
        guard bucketItem != nil && bucketItem?.id != nil else{
            return
        }
        
        let img = image.resized(toWidth: 800)
        guard img != nil else{
            return
        }
        
        let ip = IndexPath(item: 3, section: 0)
        var zeroItems = images.count > 0 ? false : true

        
        if zeroItems{
            nonImgCells.removeLast()
            collectionView.deleteItems(at: [ip])
        }
        images.insert(image, at: 0)

        collectionView.insertItems(at: [ip])
        cellUploading = (collectionView.cellForItem(at: ip) as! DetailImgCell)
        cellUploading?.showUploading()
        
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
            _ = uploadTask.observe(.success) { (snapshot) in
                guard snapshot.error == nil else{
                    print("error sucess upload", snapshot.error!)
                    return
                }
                if snapshot.status == StorageTaskStatus.success{
                    self.cellUploading?.uploadSuccess()
                    print("snapshot uploaded successfully")
                }
            }
            
            _ = uploadTask.observe(.failure, handler: { (snapshot) in
                self.cellUploading?.uploadFail()
            })
            
            _ = uploadTask.observe(.progress) { (snapshot) in
                guard snapshot.error == nil else{
                    print("error uploading ", snapshot.error!)
                    return
                }
                if let progress = snapshot.progress{
                    let percentComplete = Int(progress.fractionCompleted * 100)
                    print("fraction completed \(percentComplete)%")
                }
            }
            
        }
    }
    
    @objc func showAlert(){
        let actionSheet = UIAlertController(title: "Add Images", message: nil, preferredStyle: .actionSheet)
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
        
        print("img count", images.count)
        print("nonImgCells count", nonImgCells.count)
        
        return images.count + nonImgCells.count
//        if images.count > 0{
//
//        } else{
//            return 4
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0, let bucketItem = bucketItem{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCell", for: indexPath) as? StatusCell{
                cell.delegate = self
                cell.configure(bucketItem: bucketItem)
                return cell
            }
        }
        if indexPath.row == 1, let bucketItem = bucketItem{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDataCell", for: indexPath) as? ItemDataCell{
                cell.configure(item: bucketItem)
                return cell
            }
        }
        if indexPath.row == 2, let bucketItem = bucketItem{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDetails", for: indexPath) as? DetailsCell{

                cell.configure(item: bucketItem)
                cell.delegate = self
                return cell
            }
        }
        if indexPath.row == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCamera", for: indexPath)
            let lightGrayView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            lightGrayView.backgroundColor = UIColor().extraLightGrey
            cell.selectedBackgroundView = lightGrayView
            return cell
        }
        if images.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImage", for: indexPath)
            return cell
        } else{
            if indexPath.row > 3{
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailImgCell{
                    print("the indexpath.row", indexPath.row)
                    print("the nonImgCells.count", nonImgCells.count)
                    cell.configure(imgUrl: images[indexPath.row - nonImgCells.count])
                    return cell
                }
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
        if indexPath.row == 3{
            showAlert()
        } else if indexPath.row > 3{
            
            if images.count == 0{
                showAlert()

            } else{
                if let vc = storyboard.instantiateViewController(withIdentifier: "LargeImageVC") as? LargeImageVC{
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset = collectionView.contentInset.right + collectionView.contentInset.left
        let width = collectionView.frame.width / 2 - spaceBetweenCells / 2 - inset / 2 - 1
        
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.width - inset, height: 95)
        }
        
        if indexPath.row == 1{
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

        

        
        if indexPath.row == 2{
            return CGSize(width: collectionView.frame.width - inset, height: 55)
        }
        
        if indexPath.row == 3{
            return CGSize(width: collectionView.frame.width - inset, height: 40)
        }
        
        if images.count == 0 && indexPath.row == 4{
            return CGSize(width: collectionView.frame.width - inset, height: 150)
        }
        
        return CGSize(width: width, height: width)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return UIModalPresentationStyle.none }
    

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

extension BucketDetails: DetailsCellDelegate{
    func goToAddress(bucketItem: BucketItem){
        if let coord2D = bucketItem.coordinate2D(){
            let placemark = MKPlacemark(coordinate: coord2D)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = bucketItem.addressFull()
            mapItem.openInMaps(launchOptions: nil)
        }
        print("bucketItem coord", bucketItem.pinLat)
    }
}

extension BucketDetails: StatusCellDelegate{
    func statusBtnPress(btn: UIButton) {
        print("status btn press")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "StatusVC") as? StatusVC{
            print("status btn press2")

            vc.modalPresentationStyle = .popover
            vc.delegate = self
            vc.preferredContentSize = CGSize(width: 200, height: 60)
            
            if let presentationController = vc.popoverPresentationController {
//                presentationController.delegate = self
                presentationController.permittedArrowDirections = .right
                presentationController.sourceView = self.collectionView
                presentationController.sourceRect = CGRect(x: 0, y: 0, width: 50, height: 50)// CGRect(0, 0, 50, 50)
                
//                vc.popoverPresentationController?.sourceView = collectionView
                present(vc, animated: true, completion: nil)
            }
            

        }
    }
}

extension BucketDetails: StatusVCDelegate {
    func didSelectStatus(status: ItemStatus){
        print("status selected", status.rawValue)
    }
}









