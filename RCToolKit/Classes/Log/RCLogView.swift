//
//  RCLogView.swift
//  RCToolKit
//
//  Created by yoyo on 2022/10/25.
//

import UIKit
import SnapKit

class LogCell: UITableViewCell {
    private var content: UILabel = UILabel()
    private var colorView: UIView  = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor  = .clear
        self.backgroundView?.backgroundColor = .clear
        
        self.colorView.backgroundColor = .clear
        self.content.backgroundColor = .clear
        
        self.contentView.addSubview(self.colorView)
        self.colorView.addSubview(self.content)
        
        self.content.rc.textColor(.white)
            .numberOfLines(0)
            .font(UIFont.systemFont(ofSize: 14))
            .bgColor(.clear)
        
        self.colorView.rc.cornerRadius(12.25)
        
        self.colorView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        self.content.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func update(_ log: String,bgColor:UIColor) {
        content.text = log
        colorView.backgroundColor = bgColor
    }
}

public class RCLogView: UIView {
    private var fomatter_:logFomatreralbel?
    private let tableView:UITableView = UITableView(frame: .zero, style: .plain)
    private var dataSource:Array<RCLogMessage> = []
    private let logCellId = "logCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tableView)
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(LogCell.self, forCellReuseIdentifier: logCellId)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
    }
}
extension RCLogView:LogOutputable {
    public var formatter: logFomatreralbel? {
        get {
            guard let fmatter = fomatter_ else {
                fomatter_ = RCDefaultFormatter.default
                return fomatter_!
            }
            return fmatter;
        }
        set {
            fomatter_ = newValue
        }
    }
    
    public func logMessage(msg: RCLogMessage) {
        if self.dataSource.count > 1000 {
            self.dataSource.removeAll()
        }
        self.dataSource.append(msg)
        let indexPath = IndexPath(row: self.dataSource.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    public func flush() {

        self.tableView.reloadData()
    }
    
}
extension RCLogView:UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: logCellId, for: indexPath) as! LogCell
        let log = self.dataSource[indexPath.row]
        let text = self.formatter!.formatter(log, emo: true)
        cell.update(text, bgColor: log.type.color)
        return cell
    }
    
    
}
