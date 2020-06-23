//
//  ViewController.swift
//  CoreDataRelationship
//
//  Created by Shawn Li on 6/12/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController
{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        print( context === mainQueueContext ? "Equal" : "Not Equal")
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
//        addTasks()
//        fetchTask()
//        deleteTask()
        
//        addTaskWithRelationship()
//        fetchTaskWithRelationship()
        
//        deleteTaskWithRelationship()
//        deleteTaskWhenRelationshipIsDeny()
//        deleteTaskWhenRelationshipIsNoAction()
        
//        addTaskWithValidation()
//        addTaskWithRegex()
        
//        addTwoUsers()
//        fetchWithPredicate()
//        fetchWithSortDescriptor()
//        addTwoUsersWithMultiThread()
//        managedObjectAccessOnDifferentContextWithError()
//        managedObjectAccessOnDifferentContextWithoutError()
//        managedObjectAccessOnDifferentContext()
        checkChildrenAndParentContext()
    }

    //MARK: - Normal CRUD
    func addTasks()
    {
        let todoEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        
        let todo1 = NSManagedObject(entity: todoEntity, insertInto: context)
        todo1.setValue("todo1", forKey: "name")
        todo1.setValue("Good Good Study", forKey: "details")
        todo1.setValue(1, forKey: "id")
        
        let todo2 = NSManagedObject(entity: todoEntity, insertInto: context)
        todo2.setValue("todo2", forKey: "name")
        todo2.setValue("Day Day Up", forKey: "details")
        todo2.setValue(2, forKey: "id")
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTask()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do
        {
            let tasks = try context.fetch(fetchRequest)
            
            for data in tasks
            {
                print(data.value(forKey: "details") ?? "No Data Found")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTask()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do
        {
            let tasks = try context.fetch(fetchRequest)
            
            for data in tasks
            {
                context.delete(data)
                print("Delete \(data.value(forKey: "details") ?? "not") Successfully.")
            }
            
            do
            {
                try context.save()
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - OOP CRUD
    func addTaskByOO()
    {
        let todoObject1 = Task(context: context)
        todoObject1.id = 1
        todoObject1.name = "todoObj1"
        todoObject1.details = "Orange"
        
        let todoObject2 = Task(context: context)
        todoObject2.id = 2
        todoObject2.name = "todoObj2"
        todoObject2.details = "Apple"
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func fecthTaskOO()
    {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            let tasks = try context.fetch(fetchRequest)
            
            for data in tasks
            {
                print(data.details ?? "No Data Found")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTaskOO()
    {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            let tasks = try context.fetch(fetchRequest)
            
            for data in tasks
            {
                context.delete(data)
            }
            
            do
            {
                try context.save()
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - CRUD with Relationship
    func addTaskWithRelationship()
    {
        let todoObject1 = Task(context: context)
        todoObject1.id = 1
        todoObject1.name = "todoObj1"
        todoObject1.details = "Orange"
        
        let todoObject2 = Task(context: context)
        todoObject2.id = 2
        todoObject2.name = "todoObj2"
        todoObject2.details = "Apple"
        
        let userPassport = Passport(context: context)
        userPassport.expireData = Date()
        userPassport.number = "E01012345"
        
        let user = User(context: context)
        user.firstName = "Shawn"
        user.secondName = "Li"
        user.userId = 123
        
        //Assign tasks to user
        user.task = NSSet(array: [todoObject1,todoObject2])
        
        //Assign passport to user objects
        user.passport = userPassport
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTaskWithRelationship()
    {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do
        {
            let tasks = try context.fetch(fetchRequest)
            
            for task in tasks
            {
                print(task.details ?? "No Data Found")
                
                print(task.ofUser?.firstName ?? "No User first Name")
                
                print(task.ofUser?.passport?.number ?? "No User Passport")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTaskWithRelationship()
    {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do
        {
            //excute fetch request
            let users = try context.fetch(fetchRequest)
            //delete User Obj
            for user in users
            {
                context.delete(user)
            }
            //fetch task
            let fetchRequestTask = NSFetchRequest<Task>(entityName: "Task")
            let tasks = try context.fetch(fetchRequestTask)
            print("Task count \(tasks.count)")
            
            //fetch passport
            let fetchRequestPassport = NSFetchRequest<Passport>(entityName: "Passport")
            let passports = try context.fetch(fetchRequestPassport)
            print("Passports count \(passports.count)")
            
            //save
            do
            {
                try context.save()
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func deleteTaskWhenRelationshipIsDeny()
    {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do
        {
            //excute fetch request
            let users = try context.fetch(fetchRequest)
            //delete User Obj
            for user in users
            {
                for task in user.task!
                {
                    context.delete(task as! NSManagedObject)
                }
                
                context.delete(user)
            }
            //fetch task
            let fetchRequestTask = NSFetchRequest<Task>(entityName: "Task")
            let tasks = try context.fetch(fetchRequestTask)
            print("Task count \(tasks.count)")
            
            //fetch passport
            let fetchRequestPassport = NSFetchRequest<Passport>(entityName: "Passport")
            let passports = try context.fetch(fetchRequestPassport)
            print("Passports count \(passports.count)")
            
            //save
            do
            {
                try context.save()
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTaskWhenRelationshipIsNoAction()
    {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do
        {
            //excute fetch request
            let users = try context.fetch(fetchRequest)
            //delete User Obj
            for user in users
            {
                context.delete(user)
            }
            //fetch task
            let fetchRequestTask = NSFetchRequest<Task>(entityName: "Task")
            let tasks = try context.fetch(fetchRequestTask)
            print("Task count \(tasks.count)")
            
            //fetch passport
            let fetchRequestPassport = NSFetchRequest<Passport>(entityName: "Passport")
            let passports = try context.fetch(fetchRequestPassport)
            print("Passports count \(passports.count)")
            
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Validation
    
    func addTaskWithValidation()
    {
        let todoObject1 = Task(context: context)
        todoObject1.id = 1
        todoObject1.name = "todoObj1"
        todoObject1.details = "Orange"
        
        let todoObject2 = Task(context: context)
        todoObject2.id = 2
        todoObject2.name = "todoObj2"
        todoObject2.details = "Apple"
        
        let todoObject3 = Task(context: context)
        todoObject3.id = 3
        todoObject3.name = "todoObj3"
        todoObject3.details = "Banana"
        
        //Create User Obj
        
        let user = User(context: context)
        user.firstName = "Shawn"
        user.secondName = "Li"
        user.userId = 123
        
        //Assign tasks to user
        user.task = NSSet(array: [todoObject1,todoObject2,todoObject3])
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func addTaskWithRegex()
    {
        let todoObject1 = Task(context: context)
        todoObject1.id = 1
        todoObject1.name = "todoObj1"
        todoObject1.details = "Orange"
        
        let todoObject2 = Task(context: context)
        todoObject2.id = 2
        todoObject2.name = "todoObj2"
        todoObject2.details = "Apple"
        
        //Create User Obj
        
        let user = User(context: context)
        user.firstName = "Shawn"
        user.secondName = "Li"
        user.userId = 123
        
        //Assign tasks to user
        user.task = NSSet(array: [todoObject1,todoObject2])
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: - Fetching and Sorting
    func addTwoUsers()
    {
        let user = User(context: context)
        user.secondName = "User One Second name"
        user.firstName = "ali"
        
        let user2 = User(context: context)
        user2.secondName = "User Two Second name"
        user2.firstName = "Shawn"
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchWithPredicate()
    {
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        userFetchRequest.predicate = NSPredicate(format: "firstName == %@", "ali")
        
        do
        {
            let users = try context.fetch(userFetchRequest)
            
            print("Users Count \(users.count)")
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchWithSortDescriptor()
    {
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        let sortByFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        let sortBySecondName = NSSortDescriptor(key: "secondName", ascending: true)
        
        userFetchRequest.sortDescriptors = [sortByFirstName,sortBySecondName]
        
        do
        {
            let users = try context.fetch(userFetchRequest)
            
            for user in users
            {
                print("User First Name \(user.firstName ?? "Default value")")
                print("User Second Name \(user.secondName ?? "Default value")")
                print("\n\n\n")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRequestWithResultsType()
    {
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        userFetchRequest.resultType = .managedObjectResultType
        
        do
        {
            let users = try context.fetch(userFetchRequest)
            
            for user in users
            {
                let firstName = user.firstName
                print("User First Name is \(firstName ?? "Default")")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addThreeUsers()
    {
        let user = User(context: context)
        user.secondName = "Vijay"
        user.firstName = "Kumar"
        
        let secondUser = User(context: context)
        secondUser.secondName = "Subhan"
        secondUser.firstName = "Ali"
        
        let thirdUser = User(context: context)
        thirdUser.secondName = "Li"
        thirdUser.firstName = "Shawn"
        
        //Save
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRequestFaultObjects()
    {
        let userFetchRequest = NSFetchRequest<User>(entityName: "User")
        
        userFetchRequest.returnsObjectsAsFaults = true
        
        do
        {
            let users = try context.fetch(userFetchRequest)
            print("Printing fault data")
            
            //Print before fault fired
            for user in users
            {
                print("Object return \(user)")
            }
            
            //access any one property to fire fault
            for user in users
            {
                _ = user.firstName
            }
            print("\n\n\n\n Printing After Fired fault")
            
            //Print after fault fired
            for user in users
            {
                print("Object return \(user)")
            }
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
        
    }
    
    //MARK: - MultiThreading
    func addTwoUsersWithMultiThread()
    {
        DispatchQueue.global(qos: .background).async
        {
            print("Background Thread")
            print("Executing Background Thread")
            print("\(Thread.current)\n\n")
            
            self.context.perform //ensure the block operations are executed on the queue specified for the context. Since the context was created on main thread perform(_:) will change the thread to main thread
            {
                print("\(Thread.current)")
                print("Switch Main Thread")
                
                let user = User(context: self.context)
                user.secondName = "User One Second name"
                user.firstName = "ali"
                
                let user2 = User(context: self.context)
                user2.secondName = "User Two Second name"
                user2.firstName = "Shawn"
                
                //Save
                do
                {
                    try self.context.save()
                }
                catch let error as NSError
                {
                    print("Counld not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func managedObjectAccessOnDifferentContextWithError()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //context on Main Queue
        let mainQueueContext = appDelegate.persistentContainer.viewContext
        //context on Private Queue
        let privateQueueContext = appDelegate.persistentContainer.newBackgroundContext()
        //create user object on Main Queue Context
        let user = User(context: mainQueueContext)
        user.secondName = "User One Second name"
        user.firstName = "ali"
        //create task object on Private queue Context
        let task = Task(context: privateQueueContext)
        task.name = "Task Name"
        user.task = [task]
        
        //Save
        do
        {
            try self.context.save()
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func managedObjectAccessOnDifferentContextWithoutError()
    {
        //context on Main Queue
//        let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //context on Private Queue
        let privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateQueueContext.parent = context
        //create user object on Main Queue Context
        let user = User(context: context)
        user.secondName = "User One Second name"
        user.firstName = "ali"
        
//        let task1 = Task(context: privateQueueContext)
//        let task2 = Task(context: privateQueueContext)
        var task1ID: NSManagedObjectID!
        var task2ID: NSManagedObjectID!
        
        privateQueueContext.performAndWait
        {
            let task1 = Task(context: privateQueueContext)
            task1ID = task1.objectID
            //create task object on Private queue Context
            task1.name = "task1"
            task1.details = "This is task1"
            task1.id = 1
            
            let task2 = Task(context: privateQueueContext)
            task2ID = task2.objectID
            task2.name = "task2"
            task2.details = "This is task2"
            task2.id = 2
            //Save
            do
            {
                try privateQueueContext.save()
                print("Save privateQueueContext Successfully")
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
        
        user.task = NSSet(array: [self.context.object(with: task1ID), self.context.object(with: task2ID)])
        
        //Save
        do
        {
            try context.save()
            print("Save mainContext Successfully")
        }
        catch let error as NSError
        {
            print("Counld not save. \(error), \(error.userInfo)")
        }
    }
    
    func managedObjectAccessOnDifferentContext()
        {
            //context on Main Queue
//            let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            //context on Private Queue
            let privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateQueueContext.parent = context
            //create user object on Main Queue Context
            let user = User(context: context)
            user.secondName = "User One Second name"
            user.firstName = "ali"
            
//            let task1 = Task(context: privateQueueContext)
//            let task2 = Task(context: privateQueueContext)
            var task1ID: NSManagedObjectID!
            var task2ID: NSManagedObjectID!
            
            print("Current Thread is 1 \(Thread.current)\n\n\n")

            privateQueueContext.perform
            {
                let task1 = Task(context: privateQueueContext)
                task1ID = task1.objectID
                task1.name = "task1"
                task1.details = "This is task1"
                task1.id = 1
                let task2 = Task(context: privateQueueContext)
                task2ID = task2.objectID
                task2.name = "task2"
                task2.details = "This is task2"
                task2.id = 2
                //create task object on Private queue Context
                print("Current Thread is 2 \(Thread.current)\n\n\n")
                            
            }
            
            privateQueueContext.performAndWait
            {
                print("Current Thread is 4 \(Thread.current)\n\n\n")
              //Save
                do
                {
                    try privateQueueContext.save()
                    print("Save PrivateQueueContext Successfully")
                }
                catch let error as NSError
                {
                    print("Counld not save. \(error), \(error.userInfo)")
                }
            }
            
            print("Current Thread is 3 \(Thread.current)\n\n\n")
            
            user.task = NSSet(array: [context.object(with: task1ID), context.object(with: task2ID)])
            
            //Save
            do
            {
                try context.save()
                print("Save Context Successfully")
            }
            catch let error as NSError
            {
                print("Counld not save. \(error), \(error.userInfo)")
            }
        }
    
    func checkChildrenAndParentContext()
            {
                //context on Main Queue
                let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                //context on Private Queue
                let privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateQueueContext.parent = mainQueueContext
                //create user object on Main Queue Context
                let user = User(context: mainQueueContext)
                user.secondName = "User One Second name"
                user.firstName = "ali"
                
    //            let task1 = Task(context: privateQueueContext)
    //            let task2 = Task(context: privateQueueContext)
                var task1ID: NSManagedObjectID!
                var task2ID: NSManagedObjectID!
                
                print("Current Thread is 1 \(Thread.current)\n\n\n")

                privateQueueContext.perform
                {
                    let task1 = Task(context: privateQueueContext)
                    task1ID = task1.objectID
                    task1.name = "task1"
                    task1.details = "This is task1"
                    task1.id = 1
                    let task2 = Task(context: privateQueueContext)
                    task2ID = task2.objectID
                    task2.name = "task2"
                    task2.details = "This is task2"
                    task2.id = 2
                    //create task object on Private queue Context
                    print("Current Thread is 2 \(Thread.current)\n\n\n")
                                
                }
                
                privateQueueContext.performAndWait
                {
                    print("Current Thread is 4 \(Thread.current)\n\n\n")
                  //Save
                    do
                    {
                        try privateQueueContext.save()
                        print("Save PrivateQueueContext Successfully")
                    }
                    catch let error as NSError
                    {
                        print("Counld not save. \(error), \(error.userInfo)")
                    }
                }
                
                print("Current Thread is 3 \(Thread.current)\n\n\n")
                
                user.task = NSSet(array: [mainQueueContext.object(with: task1ID), mainQueueContext.object(with: task2ID)])
                
                //Save
                do
                {
                    try mainQueueContext.save()
                    print("Save Context Successfully")
                }
                catch let error as NSError
                {
                    print("Counld not save. \(error), \(error.userInfo)")
                }
            }
}

