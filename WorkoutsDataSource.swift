import UIKit

class WorkoutsDataSource: DataSource<BaseDataProvider<Workout>,WorkoutCell> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView, provider: BaseDataProvider<Workout>(isWorkout: true))
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}