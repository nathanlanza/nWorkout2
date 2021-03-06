import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import DZNEmptyDataSet

extension SelectWorkoutVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "SelectWorkoutVC" }
}

class SelectWorkoutVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blankWorkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let realm = try! Realm()
        let objects = Array(realm.objects(Workout.self).filter("isWorkout = false"))
        tableView.register(SelectWorkoutCell.self, forCellReuseIdentifier: SelectWorkoutCell.identifier)
       
        Observable.just(objects).bindTo(tableView.rx.items(cellIdentifier: SelectWorkoutCell.identifier, cellType: SelectWorkoutCell.self)) { index, workout, cell in
            cell.configure(for: workout, at: IndexPath(row: index, section: 0))
        }.addDisposableTo(db)
    }

    let db = DisposeBag()
}

class SelectWorkoutCell: UITableViewCell {}
extension SelectWorkoutCell: ConfigurableCell {
    static var identifier: String { return "SelectWorkoutCell" }
    func configure(for object: Workout, at indexPath: IndexPath) {
        textLabel?.text = object.name
        detailTextLabel?.text = object.lifts.map { $0.name }.joined(separator: ", ")
    }
}


extension SelectWorkoutVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Create a routine to be able to select a routine to format your workout.")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "To add a routine, close this page and click the \"Routines\" tab.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
