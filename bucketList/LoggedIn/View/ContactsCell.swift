//
//  ContactsCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/28/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Contacts
import FirebaseFirestore

struct ContactInfo{
    var name: String
    var number: String
}

class ContactsCell: BaseCell {
    
    var users = [User]()
    
    lazy var cvContacts: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var reuseID = "reuseID"
    
    override func setUpViews() {
        addSubview(cvContacts)
        cvContacts.register(UserCell.self, forCellWithReuseIdentifier: reuseID)
        accessContacts()
    }
    
    func accessContacts(){
        let store = CNContactStore()
        var contacts = [ContactInfo]()
        store.requestAccess(for: .contacts) { (granted, error) in
            guard error == nil else{
                return
            }
            if granted{
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactFamilyNameKey, CNContactPhoneNumbersKey as CNKeyDescriptor] as [Any]
                let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
                do{
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                        let number = contact.phoneNumbers.first?.value.stringValue ?? ""
                        let name = contact.givenName + " " + contact.familyName
                        let contactInfo: ContactInfo = ContactInfo(name: name, number: number)
                        contacts.append(contactInfo)
                    })
                    self.searchContacts(contacts: contacts)
                } catch{
                    print("unable to access contacts")
                }
                
                
            } else{
                print("access not granted")
            }
        }
    }
    
    func searchContacts(contacts: [ContactInfo]){
        var nonWhiteSpaceContacts = [ContactInfo]()
        for contact in contacts{
            var contactCheck = contact
            contactCheck.name = contact.name.trimmingCharacters(in: .whitespacesAndNewlines)
            if !contactCheck.name.isEmptyOrWhitespace() && !contactCheck.number.isEmptyOrWhitespace(){
                nonWhiteSpaceContacts.append(contactCheck)
            }
        }

        for (index, contact) in nonWhiteSpaceContacts.enumerated(){
            var onlyDigits = contact.number.digits
            if onlyDigits.count > 10{
                let qtyToRemove = onlyDigits.count - 10
                onlyDigits = String(onlyDigits.dropFirst(qtyToRemove))
            }
            nonWhiteSpaceContacts[index].number = onlyDigits
        }
        
        for item in nonWhiteSpaceContacts{
            DataService.instance.usersRef.whereField("phone", isEqualTo: item.number).getDocuments { (snapshot, error) in
                
                guard error == nil && snapshot != nil else{
                    return
                }
                for snap in snapshot!.documents{
                    let user = User(data: snap.data(), uid: snap.documentID)
                    self.users.append(user)
                    print("my user \(user.fullName)")
                    self.cvContacts.reloadData()
                }
                
            }
        }
        
    }
    
}

extension ContactsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items in section")
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellforItemAt1")
        if let cell: UserCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? UserCell{
            print("cellforItemAt2")
            cell.delegate = self
            cell.configure(user: users[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 105)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension ContactsCell: UserCellDelegate{
    
    func primaryBtnPress(user: User, btnAction: UserCellBtnActions?) {
        let batch = Firestore.firestore().batch()
        
        let requesteeDoc = DataService.instance.usersRef.document(user.uid).collection("friends").document(CurrentUser.instance.user.uid)
        let requesterDoc = DataService.instance.currentUserFriends.document(user.uid)
        
        var dict2 = CurrentUser.instance.user.friendRequestInfo()
        dict2["status"] = FriendStatus.requestReceived.rawValue
        dict2["created"] = FieldValue.serverTimestamp()
        batch.setData(dict2, forDocument: requesteeDoc)
        
        var dict = user.friendRequestInfo()
        dict["status"] = FriendStatus.requestSent.rawValue
        dict["created"] = FieldValue.serverTimestamp()
        batch.setData(dict, forDocument: requesterDoc)
        
        batch.commit { (error) in
            guard error == nil else{
                print("error is nil ", error?.localizedDescription)
                return
            }
        }
    }
    
    func secondaryBtnPress(user: User, btnAction: UserCellBtnActions?) {
        
    }
}


















