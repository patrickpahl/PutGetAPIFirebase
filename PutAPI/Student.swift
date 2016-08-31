//
//  Student.swift
//  PutAPI
//
//  Created by Patrick Pahl on 8/31/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation


class Student {
    //using a struct, so no regular 'init' needed.
    
    private let nameKey = "name"
    
    let name: String
    
    init(name: String){
        self.name = name
    }
    
    var dictionaryRepresentation: [String: AnyObject] {
        return [nameKey: name]
    }
    //This turns our data into json.
    
    var jsonData: NSData? {
        
       return try? NSJSONSerialization.dataWithJSONObject(dictionaryRepresentation, options: .PrettyPrinted)
        //'pretty printed' makes it human readable.
    }
    
    init?(dictionary: [String: AnyObject]) {
        
        guard let name = dictionary[nameKey] as? String
            else {return nil}
    
    self.name = name
    }
    
}