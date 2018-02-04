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
7. Add `pod 'RealmSwift'` before the `end` keyword in `Podfile` (see **Content of Podfile after edit** below)
8. Save the file and then go back to the Terminal session.
9. Run `$ pod install` to install Realm pods into the project.
10. From this point on, open the project with the `.xcworkspace` file.

### Installing SwipeCellKit CocoaPods:
- SwipeCellKit is a Swipeable UITableViewCell based on the stock Mail.app, implemented in Swift.
- References:
  - https://cocoapods.org/pods/SwipeCellKit
  - https://github.com/SwipeCellKit/SwipeCellKit 
1. Assuming steps 1 to 6 above for Realm were completed
2. Run `$ open Podfile -a Xcode` (to open and edit Podfile in Xcode)
3. Add `pod 'SwipeCellKit'` before the `end` keyword in `Podfile` (see **Content of Podfile after edit** below)
4. Run `$ pod install` to install Realm pods into the project.
5. Open the project with the `.xcworkspace` file.

**Content of Podfile after edit:**
```
  platform :ios, '9.0'

  target 'ToDoList' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for ToDoList

  pod 'RealmSwift'
  pod 'SwipeCellKit'

  end
```
