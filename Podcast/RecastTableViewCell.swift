//
//  RecastTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/13/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

protocol RecastTableViewCellDelegate: class {
    func didPress(on action: EpisodeAction, for cell: RecastTableViewCell)
    func expand(for cell: RecastTableViewCell, _ isExpanded: Bool)
}

class RecastTableViewCell: UITableViewCell, RecastSubjectViewDelegate {

    var subjectView: RecastSubjectView!

    let padding: CGFloat = 18

    weak var delegate: RecastTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        subjectView = RecastSubjectView()
        contentView.addSubview(subjectView)

        subjectView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.leading.bottom.trailing.equalToSuperview()
        }

        subjectView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with episode: Episode, for user: User) {
        subjectView.setup(with: episode, for: user, isExpanded: true)
    }

    func updateWithPlayButtonPress(episode: Episode) {
        subjectView.episodeMiniView.updateWithPlayButtonPress(episode: episode)
    }

    ///
    /// Mark: Delegate
    ///
    func didPress(on action: EpisodeAction, for view: RecastSubjectView) {
        delegate?.didPress(on: action, for: self)
    }

    func expand(_ isExpanded: Bool) {
        delegate?.expand(for: self, isExpanded)
    }
}





