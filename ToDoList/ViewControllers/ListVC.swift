import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskListDelegate {
    
    var tasks: [(name: String, done: Bool)] = []
    private let tableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(name: task.name, done: task.done)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            saveTasks()
            checkForEmptyState()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func checkForEmptyState() {
        if tasks.isEmpty {
            let noTasksLabel = UILabel()
            noTasksLabel.text = "No tasks available."
            noTasksLabel.textAlignment = .center
            noTasksLabel.frame = tableView.bounds
            tableView.backgroundView = noTasksLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        setupNavigationBar()
        setupTableView()
        checkForEmptyState()
        
        title = "To Do List"
    }
    
    @objc func addButtonTapped() {
        let addToDoVC = AddToDoVC()
        addToDoVC.toDoClosure = { [weak self] toDo in
            guard let self = self else { return }
            self.tasks.append((name: toDo, done: false))
            let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.checkForEmptyState()
        }
        navigationController?.pushViewController(addToDoVC, animated: true)
    }
    
    
    func taskisDoneUpdated(at index: Int, done: Bool) {
        tasks[index].done = done
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveTasks()
    }
    
    func saveTasks() {
        let taskNames = tasks.map { $0.name }
        let taskStatus = tasks.map { $0.done }
        UserDefaults.standard.set(taskNames, forKey: "taskNames")
        UserDefaults.standard.set(taskStatus, forKey: "taskStatus")
    }
    
    func loadTasks() {
        if let taskNames = UserDefaults.standard.array(forKey: "taskNames") as? [String],
           let taskStatus = UserDefaults.standard.array(forKey: "taskStatus") as? [Bool] {
            tasks = zip(taskNames, taskStatus).map { ($0, $1) }
        }
    }


    
}
