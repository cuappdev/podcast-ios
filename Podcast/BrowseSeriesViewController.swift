//
//  BrowseSeriesViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 12/28/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class BrowseSeriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchSeriesTableViewDelegate {

    let reuseIdentifier = "Reuse"
    let rowHeight: CGFloat = 95

    var series: [Series] = []
    var seriesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "Series"
        seriesTableView = UITableView(frame: .zero, style: .plain)
        seriesTableView.tableFooterView = UIView()
        seriesTableView.register(SearchSeriesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        seriesTableView.delegate = self
        seriesTableView.dataSource = self
        view.addSubview(seriesTableView)
        seriesTableView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        // todo: populate series
        seriesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seriesDetailViewController = SeriesDetailViewController(series: series[indexPath.row])
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SearchSeriesTableViewCell else { return SearchSeriesTableViewCell() }
        cell.delegate = self
        cell.configure(for: series[indexPath.row], index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = seriesTableView.indexPath(for: cell) else { return }
        let series = self.series[indexPath.row]
        series.subscriptionChange(completion: cell.setSubscribeButtonToState)
    }


}
