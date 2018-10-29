//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Amjad Khan on 29/10/18.
//  Copyright © 2018 Amjad Khan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // get managed context object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        // insertValuesToEntity()
        fetchValuesFromEntity()
    }
    
    func insertValuesToEntity() {
        
        if managedContext == nil {
            return
        }
        
        //
        // get user entity
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext!)!
        
        //
        // create user oobject model and set values
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue("Amjad Khan", forKey: "name")
        user.setValue("amjad.khan@conduent.com", forKey: "email")
        user.setValue(0, forKey: "number_of_children")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: "1990/05/21")
        user.setValue(date, forKey: "date_of_birth")
        
        
        //
        // get car entity
        let carEntity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext!)!
        
        let car1 = NSManagedObject(entity: carEntity, insertInto: managedContext)
        car1.setValue("Audi TT", forKey: "model")
        car1.setValue(2010, forKey: "year")
        car1.setValue(user, forKey: "user")
        
        let car2 = NSManagedObject(entity: carEntity, insertInto: managedContext)
        car2.setValue("BMW X6", forKey: "model")
        car2.setValue(2014, forKey: "year")
        car2.setValue(user, forKey: "user")
        
        do {
            try managedContext!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchValuesFromEntity() {
        
        let user = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        user.fetchLimit = 1
        user.predicate = NSPredicate(format: "name = %@", "Amjad Khan")
        user.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: true)]
        
        let users = try! managedContext!.fetch(user)
        
        let amjad = users.first as! User
        print(amjad.email!)
        
        let amjadCars = amjad.cars?.allObjects as! [Car]
        print(amjadCars.count)
    }

}

