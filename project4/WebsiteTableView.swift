import UIKit

class WebsiteTableView: UITableViewController {
    var websites: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites = ["google.com", "hackingwithswift.com", "fivethirtyeight.com"]
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "webView") as? ViewController {
            vc.websites = websites
            vc.chosenSite = indexPath.row
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
