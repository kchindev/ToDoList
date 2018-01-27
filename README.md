# ToDoList
An iOS exercise on TableViewController, UserDefault, CoreData, MVC, Segue, etc. with Swift 4 and Xcode 9.

### Topics Explored
- UITableViewConroller
- UIAlertController for data entry
- UserDefault to persist data
- Navigation Controller
- MVC design pattern
- Data Model
- Codable protocol and plist
- UISearchBar
- Keyboard dismissal using async with resignFirstResponder 
- CoreData query
- Realm Database https://realm.io/products/realm-database

### Installing Realm CocoaPods:
- Realm Database is an alternative to SQLite and Core Data
- Reference: https://realm.io/docs/swift/latest#installation
1. If Cocoapods not yet installed, run `$ gem install cocoapods`
2. Run `$ pod repo update` before proceeding, in case there are updates.
3. Open a Terminal session and change directory to your project folder
4. Run `$ pod init` to initial your project with CocoaPods
5. Run `$ open Podfile -a Xcode` (to open and edit Podfile in Xcode)
6. In Xcode, remove the first line and `# ` on the second line to target iOS 9.0 and above.
7. Save the file and then go back to the Terminal session.
8. Run `$ pod install` to install Realm pods into the project.
9. From this point on, open the project with the `.xcworkspace` file.

