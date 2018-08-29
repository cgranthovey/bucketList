//
//  ContactsCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/28/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Contacts

struct ContactInfo{
    var name: String
    var number: String
}

class ContactsCell: BaseCell {
    
    
    override func setUpViews() {
        let store = CNContactStore()
        var contacts = [ContactInfo]()
        store.requestAccess(for: .contacts) { (granted, error) in
            print("setUpViews")
            guard error == nil else{
                return
            }
            print("setUpViews2")
            if granted{
                print("setUpViews3")
                
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
        backgroundColor = UIColor.blue
    }
    
    func searchContacts(contacts: [ContactInfo]){
        var myContacts = contacts

        print("my contacts 0 - ", myContacts)
        for (index, contact) in myContacts.enumerated(){
            let set = CharacterSet(charactersIn: "0123456789").inverted
            myContacts[index].number = contact.number.trimmingCharacters(in: set)
        }
        print("my contacts - ", myContacts)
    }
    
}
