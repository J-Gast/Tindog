//
//  UpdateDBService.swift
//  Tindog
//
//  Created by Jorge Gastelum on 19/03/18.
//  Copyright © 2018 Jorge Gastelum. All rights reserved.
//

import Foundation
import Firebase

class UpdateDBService {
    static let instance = UpdateDBService()
    
    func observeMatch(handler: @escaping(_ matchDict: MatchModel?) -> Void){
        DatabaseService.instance.Match_Ref.observe(.value, with: { (snapshot) in
            if let matchSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                if matchSnapshot.count > 0 {
                    for match in matchSnapshot {
                        if match.hasChild("uid2") && match.hasChild("matchIsAccepted") {
                            if let matchDict = MatchModel(snapshot: match) {
                                handler(matchDict)
                            }
                        }
                    }
                } else {
                    handler(nil)
                }
            }
        })  
    }
}
