//
//  Menu.swift
//  Movies
//
//  Created by Raul Mena on 12/9/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: Menu view controller
class Menu: UITableViewController{
    
    var delegate: FeaturedDelegate?
    
    // Menu objects
    let options: [String] = ["Upcoming", "Featured", "Profile"]
    let imageNames: [String] = ["Star", "Calendar", "Profile"]
    
    // view did load
    override func viewDidLoad() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 30
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCellId")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "MenuHeaderId")
    }
    
    // MARK: number of sections in table view controller
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // MARK: cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellId") as! MenuCell
        cell.nameLabel.text = options[indexPath.item]
        cell.iconImage.image = UIImage(named: imageNames[indexPath.item])
        return cell
    }
    
    // MARK: inserting black header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderId")
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        header?.backgroundView = backgroundView
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Upcoming
        if indexPath.row == 0{
            Service.shared.fetchUpcoming { (movies) in
                self.delegate?.updateMoviesBasedOnMenu(movies: movies, title: "Upcoming")
            }
        }
        
        // Featured
        if indexPath.row == 1{
            Service.shared.fetchFeatured(1) { (movies) in
                self.delegate?.updateMoviesBasedOnMenu(movies: movies, title: "Featured")
            }
        }
    }

} // END: Menu controller

// MARK: option cell
class MenuCell: UITableViewCell{
    
    // cell constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // setup views
    private func setupViews(){
        backgroundColor = .black
        addSubview(nameLabel)
        addSubview(iconImage)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(100)]-70-[v1(20)]", views: nameLabel, iconImage)
        addConstraintsWithFormat(format: "V:[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]-8-|", views: iconImage)
      
    }
    
    // cell objects
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .white
        label.text = "Sample Option"
        return label
    }()
    
    let iconImage: UIImageView = {
        let image = UIImage(named: "Profile")
        let imageView = UIImageView(image: image)
        return imageView
    }()

} // END: option cell
