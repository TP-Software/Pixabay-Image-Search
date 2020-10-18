//
//  SearchRecentsDelegateHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit
import ReactiveSwift

class SearchRecentsDelegateHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    let viewModel: SearchViewModel
    let recentSelected: MutableProperty<String> = MutableProperty<String>("")
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchRecents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRecentsTableViewCell")!
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.text = viewModel.searchRecents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recentSelected.value = viewModel.searchRecents[indexPath.row]
    }
}
