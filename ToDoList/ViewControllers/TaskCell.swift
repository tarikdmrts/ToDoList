import UIKit

class TaskCell: UITableViewCell {
    weak var delegate: TaskListDelegate?
    var indexPath: IndexPath?
    
    private let taskNameLabel = UILabel()
    private let doneCheckbox = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Task name label
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskNameLabel)
        
        // Checkbox
        doneCheckbox.setImage(UIImage(systemName: "square"), for: .normal) // Empty box
        doneCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected) // Checked box
        doneCheckbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        doneCheckbox.translatesAutoresizingMaskIntoConstraints = false
        doneCheckbox.tintColor = .systemBlue
        contentView.addSubview(doneCheckbox)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            doneCheckbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            doneCheckbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(name: String, done: Bool) {
        taskNameLabel.text = name
        doneCheckbox.isSelected = done
        
        if done {
            // Eğer görev tamamlandıysa, üst çizgi ekle
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.black
            ]
            let attributedString = NSAttributedString(string: name, attributes: attributes)
            taskNameLabel.attributedText = attributedString
        } else {
            // Eğer görev tamamlanmadıysa, üst çizgiyi kaldır
            let attributes: [NSAttributedString.Key: Any] = [:] // Boş özellikler
            let attributedString = NSAttributedString(string: name, attributes: attributes)
            taskNameLabel.attributedText = attributedString
        }
    }
    
    @objc private func checkboxTapped() {
        doneCheckbox.isSelected.toggle()
        
        if let indexPath = indexPath {
            // Delegate'ye görev tamamlandı bilgisini gönder
            delegate?.taskisDoneUpdated(at: indexPath.row, done: doneCheckbox.isSelected)
        }
        
        // Task görünümünü güncelle
        if let name = taskNameLabel.text {
            configure(name: name, done: doneCheckbox.isSelected)
        }
    }
}
