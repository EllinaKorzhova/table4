//
//  ViewController.swift
//  tableshaffle
//
//  Created by Эллина Коржова on 12.05.23.
//
import UIKit

final class ViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, CellData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CellData>

   var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
   lazy var dataSource = createDiffableDataSource()
   lazy var shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTapped))

    var data = [CellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...50 {
            data.append(CellData(title: i))
        }
        setupView()
    }

   override func viewDidAppear(_ animated: Bool) {
        reload()
  }
}

 extension ViewController {
    func setupView() {
        view.backgroundColor = .white
        title = "Table"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = shuffleButton
        setupTable()
    }

    func setupTable() {
        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionId = dataSource.sectionIdentifier(for: indexPath.section) else {
            return
        }

         switch sectionId {
    case .numbers:
             data[indexPath.row].isFavorite.toggle()
           move(to: indexPath)
        }
    }

     func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            var content = cell.defaultContentConfiguration()
            content.text = "\(item.title)"
            if self.data[indexPath.row].isFavorite {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.contentConfiguration = content
            return cell
        }
        return dataSource
    }
}

 extension ViewController {
    @objc
    func shuffleTapped() {
        data.shuffle()
        reload()
    }

    func reload() {
        var snapshot = Snapshot()
        snapshot.appendSections([.numbers])
        snapshot.appendItems(data, toSection: .numbers)
       dataSource.apply(snapshot, animatingDifferences: true)
    }

    func move(to indexPath: IndexPath) {
        let itemToMove = data[indexPath.row]
        reload()
        if itemToMove.isFavorite {
            data.remove(at: indexPath.row)
            data.insert(itemToMove, at: 0)
            reload()
        }
    }
}


