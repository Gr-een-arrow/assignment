import Foundation
import Glibc

extension Int{
    func getInput(_ onScreen: String = "") -> Int{
        print(onScreen, terminator: " ")
        guard let val = Int(readLine() ?? " ") else{
            print("Cannot covert string to input: Try again:")
            return getInput(onScreen)
        }
        return val
    }
}

extension String{
  func getInput(_ onScreen: String = "") -> String{
    print(onScreen, terminator: " ")
    guard let val = readLine() else{
      print("Error... Try again")
      return getInput(onScreen)
    }
    return val
  }
}

protocol LibraryDetails{
  func details()
  func logOut()
}

extension LibraryDetails{
  func details(){
    let choice = 0.getInput("\n\n1. Department Vice  ||  2. All Books\n")
    switch choice{
      case College.Choices.one.rawValue:
      College.libraries.forEach({
        print("------------------------------------------------\nDepartment: \($0.department)\n:::::::::\n  Book\n:::::::::")
        $0.books.forEach({ if $0.count > 0{ print("📖 \($0.name) \n🆔 Id: \($0.id) \n\n") } }) 
      })
      
      case College.Choices.two.rawValue:
      print("\n----------------------------------------\n\t\t\t📚 All Books 📚\n----------------------------------------")
      College.allBooks.forEach({ if $0.count > 0 { print("📖 \($0.name) \n🆔 Id: \($0.id) \n\n") } })

      default:
      print("Wrong Input")
      details()
    }
  }

  func changePassword(_ password: String) -> String?{
    let pass = "".getInput("\n\t\t\tEnter Your current password  🟠R  Type (c) to cancel the process")
    if pass == "c"{
      return nil
    }
    if pass != password{
      print("Password Doesn't match")
      changePassword(password)
    }
    let newpass = "".getInput("Enter New password:")
    let confirm = "".getInput("Confirm password:")
    if newpass != confirm { print("Password and confirm password not matching"); changePassword(password) }
    return newpass
  }

  func logOut(){
    print("\n\t\t\t\t\tYou Are Logged out\n\n")
  }
}


// ----------------------------------------------------------------------------------- //

class College{  // class college
  var appIsRunning:Bool = true
  static var libraries: [DepLib] = []
  static var students: [Student] = []
  static var allBooks: [DepLib.Book] = []
  
  enum Department: Int{
    case MCA = 1, ECE, MECH, IT
  }

  enum Choices: Int{
    case one = 1, two, three, four, five, six, seven
  }

  // ----------------------------------------------------------------

  class DepLib{  // class Department library
    var department: String
    var books: [Book] = []
  
    init(dep: String){
      self.department = dep
    }
    
    struct Book{  // structure Book
      var id: Int
      var name: String
      var releaseYear: Int
      var author: String
      var count: Int
    }
  
    func addBook(id: Int, name: String, releaseYear: Int, author: String, count: Int){
      let book1 = Book(id: id, name: name, releaseYear: releaseYear, author: author, count: count)
      books.append(book1)
      College.allBooks.append(book1)
    }

//     func removeBook() {
      
// }
    
  }

  // ------------------------------------------------------------------

  class Admin: LibraryDetails{  // class admin
    var count: Int = 1000
    var username: String = "admin"
    var password: String = "administrator"
  
    static let adminObj = Admin()
  
    func addStud(){ // to add student in library system
      let name = "".getInput("Enter Student Name:")
      print("Student Departmen: 1. MCA, 2. ECE, 3. MECH, 4. IT")
      let ch = 0.getInput()
      var dept = ""
      
      switch ch{
      case Department.MCA.rawValue:
      dept = "MCA"
  
      case Department.ECE.rawValue:
      dept = "ECE"
  
      case Department.MECH.rawValue:
      dept = "MECH"
  
      default:
      print("Wrong Input"); addStud()
      }
      count += 1
      let id = count
      let year = 0.getInput("Enter Student joined Year:")
      if year > 2022 || year<2018{
        print("only students between 2018 to 2022 Batch Allowed")
        addStud()
      }
      let rollNo: String = "".getInput("Enter Student rollNo:")
      let pattern = "\(year%100)\(dept.lowercased())"
      let range = NSRange(location: 0, length: rollNo.utf16.count)
      let regex = try! NSRegularExpression(pattern: pattern)
      if regex.firstMatch(in: rollNo, options: [], range: range) == nil{
        print("roll no must be last two digits of year folllowed by department ends with sudent roll")
      addStud()
      }
      print("Generated Student Id is \(id)")
      let pass: String = "".getInput("Enter Password for Studen \(name): (password must be 6 character long): ")
      if pass.count < 6{
        print("Password must be 6 character long")
        addStud()
      }
      let student1 = Student(id: id, name: name, dept: dept, rollNo: rollNo, year: year)
      student1.password = pass
      College.students.append(student1)
      print(College.students)
  
      print("Student Added Succesfully")  
      adminPage()
    }

    // function for admin to add new book to the library
  
    func addBook(){  
      let dep = "".getInput("Enter Department That you want to add:")
      start:
      for i in College.libraries{
        if i.department == dep.uppercased(){
          let id = 0.getInput("Enter Book Id:")
          if !College.allBooks.filter({$0.id == id}).isEmpty{
            print("Book With Same Id Already Exist")
            continue start
          }
          let name = "".getInput("Enter Name:")
          let year = 0.getInput("Enter Release year:")
          let author = "".getInput("Enter author Name:")
          let count = 0.getInput("Enter How Many Books:")
  
          i.addBook(id: id, name: name, releaseYear: year, author: author, count: count)
        }
      }
      print("Book Added Successfully")
    }

    func removeBook() {
      
    }
  
    func studDetails(){  // function for display student details for admin
      College.students.forEach({print("//------------------\nStudent name: \($0.name) \nStudent Id: \($0.id)\n---------------------//")})
      let id = 0.getInput("Enter Student id for more details or Enter 0 for Go Back:")
      if id == 0{ adminPage() }
      else{
        for i in College.students{
          if i.id == id{
            print("⏩ Student name: \(i.name) \n⏩ Student id: \(i.id)")
            print("⏩ Books yet to Return: ", terminator: "")
            if i.holdings.isEmpty{ print("Nil") }
            else { 
              i.holdings.forEach({
                print("Name: \($0.name) \nDays Left to submit: \(Int.random(in: 1...30))")
              })
              
            }
          }
        }
      }
    }

    func adminPage(){  // admin login function 
      print("\t\t\t\t\tAdministration")
      let choice: Int = 0.getInput("1. Student Details || 2. Add Book  ||  3. Remove Book  ||  4.Add a Student  ||  5.Change Password  ||  6. Book Details  7. Log Out")
  
      switch choice{
        case Choices.one.rawValue:
        studDetails()
        adminPage()
  
        case Choices.two.rawValue:
        addBook()
        adminPage()
      
        case Choices.three.rawValue:
        removeBook()
        adminPage()
  
        case Choices.four.rawValue:
        addStud()
        adminPage()
  
        case Choices.five.rawValue:
        let pass = changePassword(password)
        if pass == nil{ print("Last Action Terminated") }
        else { password = pass! }

        case College.Choices.six.rawValue:
        details()
        adminPage()
        
        case Choices.seven.rawValue:
        logOut()
  
        default:
        print("Wrong Input"); return adminPage()
      } 
    }
  }
  
// -----------------------------------------------------------------
  
  class Student: LibraryDetails{  // Inner class student for admin
    var password: String = ""
    var holdings: [DepLib.Book] = []
    
    var id: Int
    var name: String
    var dept: String
    var rollNo: String
    var year: Int
  
    init(id: Int, name: String, dept: String, rollNo: String, year: Int){
      self.id = id
      self.name = name
      self.dept = dept
      self.rollNo = rollNo
      self.year = year
    }
  
    func issue(){
  
    }
  
    func rent(){
      // if holdings.count > 2{ print("You already Have 3 books in hold... issue one to rent a Book") }
      // else { 
      //   let rent = 0.getInput("Enter Boom Id That you wanna Rent:")
      //   College.allBooks.forEach({ if $0.id != rent || $0.count == 0 { print("Book Not available") }
      //     else{ holdings.append($0); $0.count -= 1 } })
      // }
    }

    func stuPage(){
      let choice = 0.getInput("\t\t\t\t\tStudent Page \n1. Issue Your Book  ||  2.Rent A book  || 3. Change Password  4. Books Details")
      switch choice{
        case College.Choices.one.rawValue:
        issue()
        stuPage()

        case College.Choices.two.rawValue:
        rent()
        stuPage()

        case College.Choices.three.rawValue:
        let pass = changePassword(password)
        if pass == nil{ print("Last Action Terminated") }
        else { password = pass! }
        

        case College.Choices.four.rawValue:
        details()

        default:
        print("Enter Correct Value:")
        stuPage()
      }
    }
  }

  // -------------------------------------------------------------

  func loginPage(_ admin: Admin){   // initial stage of the program
    print("\t\t\t\t\tCollege Library management System ")
    let choice: Int = 0.getInput("1. Admin Login  -------  2. Student Login  -------   3. Exit\n")
    switch choice{
      case Choices.one.rawValue:
      let user: String = "".getInput("Enter UserName:")
      if admin.username == user {
        let pass: String = "".getInput("Enter pasword:")
        if pass == admin.password{
          // let admin = Admin.adminObj
          admin.adminPage()
        }
        else {Glibc.system("clear"); print("Wrong password"); return loginPage(admin) }
      }
      else {Glibc.system("clear"); print("Wrong UserName"); return loginPage(admin) }

      case Choices.two.rawValue:
      let id1: Int = 0.getInput("Enter Student Id:")
      let i = College.students.filter({$0.id == id1})
      guard !i.isEmpty else{
        Glibc.system("clear")
        print("Wrong Id"); return loginPage(admin)
      }
      let pass: String = "".getInput("Enter pasword:")
      if i[0].password == pass{
        i[0].stuPage()
      }
      else { print("Wrong Password"); return loginPage(admin) }

      case Choices.three.rawValue:
      appIsRunning = false
      break

      default:
      Glibc.system("clear")
      print("Wrong Input..")
      loginPage(admin) 
    } 
  }
}

//---------------------------

func main(){  // main function
  let mca = College.DepLib(dep: "MCA")
  mca.addBook(id: 101, name: "Introduction to Java", releaseYear: 2019, author: "author 1", count: 4)
  let eee = College.DepLib(dep: "EEE")
  eee.addBook(id: 102, name: "Introduction to electrical engineering", releaseYear: 2020, author: "author 2", count: 3)
  let ece = College.DepLib(dep: "ECE")
  ece.addBook(id: 103, name: "Introduction to  communiction Engineering", releaseYear: 2020, author: "author 3", count: 3)
  let it = College.DepLib(dep: "IT")
  it.addBook(id: 104, name: "Introduction to python", releaseYear: 2021, author: "author 4", count: 5)

  College.libraries = [mca, eee, ece, it]
  
  let adminObj = College.Admin.adminObj
  let col = College()
  while col.appIsRunning{
    col.loginPage(adminObj)
  }
  
}
main()