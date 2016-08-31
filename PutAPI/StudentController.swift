//
//  StudentController.swift
//  PutAPI
//
//  Created by Patrick Pahl on 8/31/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation


class StudentController {
    
    static let baseURL = NSURL(string: "https://studentpostapi.firebaseio.com/students")
    
    static let getterEndpoint = baseURL?.URLByAppendingPathExtension("json")
    //this will add json at the end for us.
    
    
    static func sendStudent(name: String, completion: ((success: Bool) -> Void)?){
        
        let student = Student(name: name)
        
        guard let url = baseURL?.URLByAppendingPathComponent(student.name).URLByAppendingPathExtension("json") else {
            completion?(success: false)
            return
        }
        
        NetworkController.performRequestForURL(url, httpMethod: .Put, urlParameters: nil, body: student.jsonData) { (data, error) in
            
            var success = false
            
            defer {
                completion?(success: success)
            }
            //Defer- So you don't have to call completion multiple times, commented out below.
            
            
            guard let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                    //completion?(success: false)
                    return
            }
            
            //ERROR HANDLING:
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else if responseDataString.containsString("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Success")
                //completion?(success: true)
                success = true
            }
        }
    }
    
    
    static func fetchStudents(completion: (students: [Student]) -> Void){
        
        guard let url = getterEndpoint else {
        completion(students: [])
            return
        }
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
           
            guard let data = data else {
                completion(students: [])
                return
            }
            
            guard let studentDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String: AnyObject]] else {
            completion(students: [])
            return }
            //[String:[String: AnyObject]] bc of how it is set up in firebase
       
            let students = studentDictionary.flatMap({Student(dictionary: $0.1)})
            //flatMap:
            //$0.0 is the key, $0.1 is the value. How you access the values.
            completion(students: students)
    }
        
        
}
}
    
    
    
    
