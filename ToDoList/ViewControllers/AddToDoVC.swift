import UIKit

class AddToDoVC: UIViewController {

    var toDoClosure: ((String) -> Void)?
    private let taskNameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc func addToDo() {
        guard let newTask = taskNameTextField.text, !newTask.isEmpty else {
            showAlert()
            return
        }
        toDoClosure?(newTask)
        taskNameTextField.text = ""
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        title = "Add To Do"
        
        taskNameTextField.placeholder = "Enter Task Name"
        taskNameTextField.borderStyle = .roundedRect
        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskNameTextField)
        
        let addToDoButton = UIButton(type: .system)
        addToDoButton.setTitle("Add Task", for: .normal)
        addToDoButton.addTarget(self, action: #selector(addToDo), for: .touchUpInside)
        addToDoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addToDoButton)
        
        NSLayoutConstraint.activate([
            taskNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            taskNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addToDoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToDoButton.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 20)
        ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please enter a task name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
