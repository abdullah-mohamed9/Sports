//
//  FavoriteTeam.swift
//  sportApp
//
//  Created by Ali Moustafa on 21/02/2023.
//

import UIKit
import CoreData
class FavoriteTeam: UIViewController {
    @IBOutlet weak var TableFavoriteTeam: UITableView!
//    var countriues = ["swsx","dwdw","wdwd","wdwdw","wdwdw","dwdw"]
    // Core Data variables
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext!
        var favoritePlayers: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        // Set the table view data source and delegate
        TableFavoriteTeam.dataSource = self
        TableFavoriteTeam.delegate = self
       
        
        
        
        // Initialize Core Data context
//               context = appDelegate.persistentContainer.viewContext
//
//               // Fetch favorite players from Core Data
//               let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritePlayer")
//               do {
//                   favoritePlayers = try context.fetch(fetchRequest)
//               } catch let error as NSError {
//                   print("Could not fetch. \(error), \(error.userInfo)")
//               }
//
//               // Reload table view
//               DispatchQueue.main.async {
//                   self.TableFavoriteTeam.reloadData()
//               }
           }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        context = appDelegate.persistentContainer.viewContext
        
        // Fetch favorite players from Core Data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritePlayer")
        do {
            favoritePlayers = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // Reload table view
        DispatchQueue.main.async {
            self.TableFavoriteTeam.reloadData()
        }
        
    }
    
    
       }
        
    


extension FavoriteTeam: UITableViewDataSource, UITableViewDelegate {
    
    // DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableFavoriteTeam.dequeueReusableCell(withIdentifier: "favoritecell") as! FavoriteTeamCell
        
        let favoritePlayer = favoritePlayers[indexPath.row]
        let playerName = favoritePlayer.value(forKey: "name") as? String
        cell.FavoriteTeamName.text = playerName
        
        //MARK: - make the cell look round
        cell.FavoriteTeamView.layer.cornerRadius = cell.contentView.frame.height / 2.5
        //make the image look round
        cell.FavoriteTeamImage.layer.cornerRadius = cell.FavoriteTeamImage.frame.height / 2.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the corresponding data item from your data source
           
            
            //Ali
            let favoritePlayer = favoritePlayers[indexPath.row]
            let playerName = favoritePlayer.value(forKey: "name") as? String
            
            
            // Remove the player name from favorites
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePlayer")
            
            
//            if self.sportType == "tennis"
//            {
//                request.predicate = NSPredicate(format: "name == %@", dataTeam?.result[0].player_name ?? "")
//            }
//            else {
                request.predicate = NSPredicate(format: "name == %@", playerName ?? "")
                
//            }
            
    
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                }
                try context.save()
//                isFavorite = false
            } catch {
                print("Error removing from favorites: \(error)")
            }
            //Ali
            
            
            favoritePlayers.remove(at: indexPath.row)
            // Delete the row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        self.TableFavoriteTeam.reloadData()
    }

    
    //Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
