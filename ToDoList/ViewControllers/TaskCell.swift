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
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskNameLabel)

        doneCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        doneCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        doneCheckbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        doneCheckbox.translatesAutoresizingMaskIntoConstraints = false
        doneCheckbox.tintColor = .systemBlue
        contentView.addSubview(doneCheckbox)

        NSLayoutConstraint.activate([
            taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneCheckbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            doneCheckbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(name: String, done: Bool) {
        let normalText = NSAttributedString(string: name, attributes: [:])
        let completedText: NSAttributedString

        if done {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.black
            ]
            completedText = NSAttributedString(string: name, attributes: attributes)
        } else {
            completedText = normalText
        }
        
        taskNameLabel.attributedText = done ? completedText : normalText
        doneCheckbox.isSelected = done
    }



    @objc private func checkboxTapped() {
        doneCheckbox.isSelected.toggle()
        if let indexPath = indexPath {
            delegate?.taskisDoneUpdated(at: indexPath.row, done: doneCheckbox.isSelected)
        }
    }
}
