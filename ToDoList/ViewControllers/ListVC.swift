import UIKit

class ListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,TaskListDelegate {

    var tasks : [(name: String, done:Bool)] = []
    private let tableView = UITableView()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(name: task.name,done:task.done)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
        title = "To Do List"
    }
    
    @objc func addButtonTapped() {
        let addToDoVC = AddToDoVC()
        addToDoVC.toDoClosure = { [weak self] toDo in
            self?.tasks.append((name: toDo, done: false))
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(addToDoVC, animated: true)
    }
    
    // TODO: Görev silindiğinde index hata veriyor. Uygulama çöküyor.
    func taskisDoneUpdated(at index: Int, done: Bool) {
        // Güncellenen görevin durumunu değiştirme
        tasks[index].done = done
        
        // Sadece değiştirilen satırı yeniden yükleme
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    
}

