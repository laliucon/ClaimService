//
//  CWID: 888632924
//  Created by Hung Cun on 10/15/20.
//
//  HW Assignment 1

import SQLite3
import Foundation



struct Claim : Codable {
    var uuid: String?
    var title : String?
    var date : String?
    var isSolved : Int?
    
    init(id: String?, t : String?, d:String?, s: Int?) {
        uuid = id
        title = t
        date = d
        isSolved = s
    }
}

class ClaimDao {
    
    func addClaim(cObj : Claim) {
        let sqlStmt = String(format:"insert into claim (id, title, date, isSolved) values ('%@', '%@', '%@','%@')", (cObj.uuid)!, (cObj.title)!, (cObj.date)!, (cObj.isSolved)!)
        // get database connection
        let conn = Database.getInstance().getDbConnection()
        // submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
        // close the connection
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {
                let uuid_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: uuid_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let t = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let d = String(cString: date_val!)
                let isSolved_val = sqlite3_column_text(resultSet, 3)
                let s = Int(String(cString: isSolved_val!))
                cList.append(Claim(id:id,t:t, d:d,s:s))
            }
        }
        return cList
    }
}
