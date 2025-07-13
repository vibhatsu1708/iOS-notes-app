//
//  DataController.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let dataContainer = NSPersistentContainer(name: "DataModel")
    
    static let shared = DataController()
    
    //MARK: - Data Controller init
    init() {
        //        loadPersistentData()
        dataContainer.loadPersistentStores { desc, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - to load the data
    //    func loadPersistentData() {
    //        self.dataContainer.loadPersistentStores { desc, error in
    //            if let error = error {
    //                print("Error: \(error)")
    //            }
    //        }
    //    }
    
    //MARK: - to save the data
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Successfully saved the Data!")
        } catch {
            print("Data couldn't be saved!")
        }
    }
    
    
    //MARK: - to add a new note
    func addNote(name: String, note_desc: String, star: Bool, bookmark: Bool, hidden: Bool, background_color: String, context: NSManagedObjectContext) {
        let note = Note(context: context)
        note.id = UUID()
        note.date = Date()
        note.name = name
        note.note_desc = note_desc
        note.star = star
        note.bookmark = bookmark
        note.hidden = hidden
        note.background_color = background_color
        
        save(context: context)
    }
    
    //MARK: - to edit a note
    func editNote(note: Note, name: String, note_desc: String, background_color: String, context: NSManagedObjectContext) {
        note.date = Date()
        note.name = name
        note.note_desc = note_desc
        note.background_color = background_color
        
        save(context: context)
    }
    
    //MARK: - To add a new Reminder
    func addReminder(name: String, reminder_desc: String, completed: Bool, flag: Bool, tags: String, deleteFlag: Bool, archive: Bool, context: NSManagedObjectContext) {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.date = Date()
        reminder.name = name
        reminder.reminder_desc = reminder_desc
        reminder.completed = completed
        reminder.flag = flag
        reminder.tags = tags
        // to be removed
        reminder.deleteFlag = deleteFlag
        reminder.archive = archive
        
        save(context: context)
    }
    
    //MARK: - To edit a reminder
    func editReminder(reminder: Reminder, name: String, reminder_desc: String, tags: String, context: NSManagedObjectContext) {
        reminder.date = Date()
        reminder.name = name
        reminder.reminder_desc = reminder_desc
        reminder.tags = tags
        
        save(context: context)
    }
    
    //MARK: - To add a new Purchase
    func addPurchase(name: String, purchase_desc: String, amount: String, payment_method: String, paid: Bool, spent_or_received: Bool, context: NSManagedObjectContext) {
        let purchase = Purchase(context: context)
        purchase.id = UUID()
        purchase.date = Date()
        purchase.name = name
        purchase.purchase_desc = purchase_desc
        purchase.amount = amount
        purchase.payment_method = payment_method
        purchase.paid = paid
        purchase.spent_or_received = spent_or_received
        
        save(context: context)
    }
    
    //MARK: - To edit a Purchase
    func editPurchase(purchase: Purchase, name: String, purchase_desc: String, amount: String, payment_method: String, paid: Bool, spent_or_received: Bool, context: NSManagedObjectContext) {
        purchase.date = Date()
        purchase.name = name
        purchase.purchase_desc = purchase_desc
        purchase.amount = amount
        purchase.payment_method = payment_method
        purchase.paid = paid
        purchase.spent_or_received = spent_or_received
        
        save(context: context)
    }
    
    //MARK: - To add a new Timer
    func addTimer(name: String?, desc: String?, duration: Double, isCompleted: Bool, context: NSManagedObjectContext) {
        let timer = Timers(context: context)
        timer.date = Date()
        timer.name = name
        timer.desc = desc
        timer.duration = duration
        timer.isCompleted = isCompleted
        timer.flag = false
        
        save(context: context)
    }
    
    //MARK: - To edit a Timer
    func editTimer(timer: Timers, name: String?, desc: String?, duration: Double, isCompleted: Bool, context: NSManagedObjectContext) {
        timer.date = Date()
        timer.name = name
        timer.desc = desc
        timer.duration = duration
        timer.isCompleted = isCompleted
        
        save(context: context)
    }
}
