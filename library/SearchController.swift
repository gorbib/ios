import UIKit
import SwiftyJSON

class SearchController: UITableViewController, UISearchBarDelegate {

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 74, height: 44))


    @IBOutlet weak var notFoundMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var endIndicator: UILabel!
    
    /**
    Search query
    */
    var searchQuery = ""
    
    /**
    Result of search
    */
    var searchResults:[Book] = []
    
    /**
    Count of **all** search items on **server**
    */
    var searchResultsTotal = 0;
    
    /**
    Current page of search results
    */
    var page = 0
    
    
    var freeze = false; // Prevent some times execution
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

        // Add Search bar to navigationbar
        searchBar.placeholder = NSLocalizedString("Ищите в библиотеке", comment: "Search bar placeholder text")
        searchBar.tintColor = UIColor.orange
        searchBar.spellCheckingType = .yes
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        searchBar.becomeFirstResponder()

    }

    // Change text in search bar event
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        if !searchQuery.isEmpty {

            // Reset all search parameters
            self.searchResults.removeAll()
            tableView.reloadData()
            page = 0

            API.sharedInstance.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            }
            // 0.5 second delay before searching
            self.perform(#selector(SearchController.find), with: nil, afterDelay: 0.5)

        } else {
            endIndicator.isHidden = true
            searchResults.removeAll()
            tableView.reloadData()
        }
        
    }

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath) as! BooksListItem


        let book = searchResults[(indexPath as NSIndexPath).row]
        
        cell.title.text = book.title

        if let isbn = book.isbn, let url = URL(string: "https://bcover.tk/" + isbn) {

            cell.cover.alpha = 0.3
            cell.cover.hnk_setImageFromURL(url, placeholder: UIImage(named:"empty"), format: nil, failure: {
                error in

                UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                    cell.cover.alpha = 1
                }, completion: nil)
            }) {
                image in
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    cell.cover.alpha = 1
                    cell.cover.image = image
                }, completion: nil)

            }
        } else {
            cell.cover.image = UIImage(named: "empty")
        }

        if let author = book.author {
            cell.author.isHidden = false
            cell.author.text = author
        } else {
            cell.author.isHidden = true
        }

        cell.departaments.text = ""
        for departament in book.departament {
            cell.departaments.text! += " " + departament
        }


        cell.type.text = book.subtitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.performSegue(withIdentifier: "ShowBook", sender: (indexPath as NSIndexPath).row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        // When user scroll to bottom of list
        if (indexPath as NSIndexPath).row > self.searchResults.count-2 {
            
            // If we have more search results — load them
            if (self.searchResults.count < self.searchResultsTotal && !self.freeze){
            
                self.freeze = true
            
                self.page += 1
            
                print("Reader: — I need more books. Give me more! (\(String(self.page))x)")
                
                self.find()
            
            // If this is all, show end indicator
            } else {
                endIndicator.isHidden = false
                
                print("Librarian: It is all books, no more. Maybe want something other?")
            }
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    
    /**
    Search items
    */
    func find() {

        self.activityIndicator.isHidden = false
        self.notFoundMessage.isHidden = true

        
        API.sharedInstance.search(self.searchQuery, forPage: self.page, fail: {
            error in

            self.activityIndicator.isHidden = true

            print(error)

//            let alertController = UIAlertController(title: "Не получилось", message:
//                "Библиотекарь ушёл, но скоро вернётся", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Ладно", style: UIAlertActionStyle.Default,handler: nil))
//
//            self.presentViewController(alertController, animated: true, completion: nil)
        }) {
            books, count in
            
            self.freeze = false
            
            //self.navigationItem.title = String(format: NSLocalizedString("Результаты поиска", comment: "Title on search page, when searching complete"), self.searchQuery)
                

            self.searchResultsTotal = count


            self.tableView.beginUpdates()

            let insertedIndexPathRange = self.searchResults.count..<self.searchResults.count + books.count
            let insertedIndexPaths = insertedIndexPathRange.map { IndexPath(row: $0, section: 0) }


            self.tableView.insertRows(at: insertedIndexPaths, with: .fade)

            self.searchResults += books

            self.tableView.endUpdates()


            //self.tableView.reloadData()
            
            self.activityIndicator.isHidden = true;
            
            /*if(self.searchResults.count > 0) {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.perMillSymbol = " "
                
                self.navigationItem.title = String(format:declOfNum(self.searchResultsTotal, titles: ["Нашлась %@ книга", "Нашлось %@ книги", "Нашлось %@ книг"]),
                    formatter.stringFromNumber(self.searchResultsTotal)!
                )
            }*/
                
            self.notFoundMessage.isHidden = (self.searchResults.count > 0)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? BookViewController , segue.identifier == "ShowBook" {
            let indexPath = sender as! Int

            vc.book = self.searchResults[indexPath]
        }
    }
}
