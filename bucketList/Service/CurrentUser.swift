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
                print("getCurrentUser")
                guard error == nil else{
                    print("error getting current user", error!)
                    onComplete(false)
                    return
                }
                print("getCurrentUser1")
                if let snapshot = snapshot, let data = snapshot.data(){
                    print("getCurrentUser2", snapshot)
                    print("getCurrentUser3", snapshot.data())
                    print("getCurrentUser4", snapshot.documentID)
                    self.user = User.init(data: data, uid: snapshot.documentID)
                    onComplete(true)
                } else{
                    onComplete(false)
                }
            }
        }
        
    }
    
}
