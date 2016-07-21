import UIKit
import SwiftyJSON

class SearchController: UITableViewController, UISearchBarDelegate {

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.size.width - 74, 44))


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
        sendScreenView()

        tableView.registerNib(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

        // Add Search bar to navigationbar
        searchBar.placeholder = NSLocalizedString("Ищите в библиотеке", comment: "Search bar placeholder text")
        searchBar.tintColor = .orangeColor()
        searchBar.spellCheckingType = .Yes
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        searchBar.becomeFirstResponder()

    }

    // Change text in search bar event
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        searchQuery = searchText.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

        NSObject.cancelPreviousPerformRequestsWithTarget(self)

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
            self.performSelector(#selector(SearchController.find), withObject: nil, afterDelay: 0.5)

        } else {
            endIndicator.hidden = true
            searchResults.removeAll()
            tableView.reloadData()
        }
        
    }

    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Book", forIndexPath: indexPath) as! BooksListItem


        let book = searchResults[indexPath.row]
        
        cell.title.text = book.title

        if let isbn = book.isbn, url = NSURL(string: "http://bcover.tk/" + isbn) {

            cell.cover.alpha = 0.3
            cell.cover.hnk_setImageFromURL(url, placeholder: UIImage(named:"empty"), format: nil, failure: {
                error in

                UIView.animateWithDuration(0.1, delay: 0, options: [], animations: {
                    cell.cover.alpha = 1
                }, completion: nil)
            }) {
                image in
                UIView.animateWithDuration(0.3, delay: 0, options: [], animations: {
                    cell.cover.alpha = 1
                    cell.cover.image = image
                }, completion: nil)

            }
        } else {
            cell.cover.image = UIImage(named: "empty")
        }

        if let author = book.author {
            cell.author.hidden = false
            cell.author.text = author
        } else {
            cell.author.hidden = true
        }

        cell.departaments.text = ""
        for departament in book.departament {
            cell.departaments.text! += " " + departament
        }


        cell.type.text = book.subtitle
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.performSegueWithIdentifier("ShowBook", sender: indexPath.row)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       
        // When user scroll to bottom of list
        if indexPath.row > self.searchResults.count-2 {
            
            // If we have more search results — load them
            if (self.searchResults.count < self.searchResultsTotal && !self.freeze){
            
                self.freeze = true
            
                self.page += 1
            
                print("Reader: — I need more books. Give me more! (\(String(self.page))x)")
                
                self.find()
            
            // If this is all, show end indicator
            } else {
                endIndicator.hidden = false
                
                print("Librarian: It is all books, no more. Maybe want something other?")
            }
        }

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }

    
    /**
    Search items
    */
    func find() {

        // Do not track «load more» requests
        if page == 0 {
            trackEvent("books", action: "search", label: self.searchQuery, value: 1)
        }

        self.activityIndicator.hidden = false
        self.notFoundMessage.hidden = true

        
        API.sharedInstance.search(self.searchQuery, forPage: self.page, fail: {
            error in

            self.activityIndicator.hidden = true

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
            let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }


            self.tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)

            self.searchResults += books

            self.tableView.endUpdates()


            //self.tableView.reloadData()
            
            self.activityIndicator.hidden = true;
            
            /*if(self.searchResults.count > 0) {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.perMillSymbol = " "
                
                self.navigationItem.title = String(format:declOfNum(self.searchResultsTotal, titles: ["Нашлась %@ книга", "Нашлось %@ книги", "Нашлось %@ книг"]),
                    formatter.stringFromNumber(self.searchResultsTotal)!
                )
            }*/
                
            self.notFoundMessage.hidden = (self.searchResults.count > 0)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? BookViewController where segue.identifier == "ShowBook" {
            let indexPath = sender as! Int

            vc.book = self.searchResults[indexPath]
        }
    }
}
