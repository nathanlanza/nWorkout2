import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet

extension LiftTypeTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "LiftTypeTVC" }
}

class LiftTypeTVC: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var liftTypes = Variable(UserDefaults.standard.value(forKey: "liftTypes") as? [String] ?? [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
       
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupRx()
    }
   
    func setupRx() {
        liftTypes.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, string, cell in
            cell.textLabel?.text = string
        }.addDisposableTo(db)
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let alert = UIAlertController(title: "Add new lift type", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                //
            }
            
            let okay = UIAlertAction(title: "Okay", style: .default) { _ in
                guard let name = alert.textFields?.first?.text else { fatalError() }
                self.liftTypes.value.append(name)
                UserDefaults.standard.setValue(self.liftTypes.value, forKey: "liftTypes")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okay)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }).addDisposableTo(db)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { name in
            self.didSelectLiftName(name)
        }).addDisposableTo(db)
        
    }
   
    var didSelectLiftName: ((String) -> ())!
    let db = DisposeBag()
}

extension LiftTypeTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have no exercise types, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click the + in the top right to add a new exercise type.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
