//
//  LoadJokesViewController.swift
//  2.3_ChackNorris_Realm
//
//  Created by Sergey on 31.07.2024.
//

import UIKit

class LoadJokesViewController: UITableViewController {
    
    var itemsManager = ItemsManager.shared
    
    var joke: [JokeCodable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Загрузить",
            style: .plain,
            target: self,
            action: #selector(didTapLoadJokes))
    }
    
    @objc private func didTapLoadJokes() {
        DownloadManager.shared.downloadJoke(categoryName: nil) {[weak self] result in
            switch result {
            case .success(let jokeCodable):
                
                DispatchQueue.main.async {
                    self?.itemsManager.addJoke(joke: jokeCodable)
                    self?.joke.append(jokeCodable)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joke.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = joke[indexPath.row].value
        config.secondaryText = joke[indexPath.row].categories.reduce("", +)
        cell.contentConfiguration = config
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}