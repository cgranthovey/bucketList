//
//  CurrentUser
//  bucketList
//
//  Created by Christopher Hovey on 7/23/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import FirebaseAuth

class CurrentUser{
    
    fileprivate static var _instance = CurrentUser()
    
    static var instance: CurrentUser{
        return _instance
    }
    
    var user: User!
    
    typealias Completion = (_ success: Bool) -> Void
    func getCurrentUserData(onComplete: @escaping Completion) {
        if let currentUser = Auth.auth().currentUser{
            DataService.instance.usersRef.document(currentUser.uid).addSnapshotListener { (snapshot, error) in
                guard error == nil else{
                    print("error getting current user", error!)
                    onComplete(false)
                    return
                }
                print("why nothing? ", snapshot?.data())
                if let snapshot = snapshot, let data = snapshot.data(){
                    self.user = User.init(data: data, uid: snapshot.documentID)
                    print("the user is - ", self.user)
                    onComplete(true)
                } else{
                    print("the user is false - ", self.user)
                    onComplete(false)
                }
            }
        }
        
    }
    
}
