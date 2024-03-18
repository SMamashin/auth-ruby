require 'sqlite3'

class ConnectDB
  def initialize(db_name)
    @db_name = db_name
    @db = SQLite3::Database.new(@db_name)
  end

  def execute_sql(sql, params = [])
    @db.execute(sql, params)
  rescue SQLite3::Exception => e
    puts "Database error: #{e}"
  rescue StandardError => e
    puts "Exception in _query: #{e}"
  end

  def select_sql(sql, params = [])
    @db.execute(sql, params)
  end

  def close_db
    @db.close
  end
end

class UserAuthApp
  def initialize(db)
    @db = db
  end

  def run
    puts "Добро пожаловать в систему авторизации"
    print "Введите логин: "
    username = gets.chomp
    print "Введите пароль: "
    password = gets.chomp

    authenticate(username, password)
  end

  def authenticate(username, password)
    if username.empty? || password.empty?
      puts "Ошибка: Необходимо ввести логин и пароль!"
      return
    end

    sql = "SELECT * FROM users WHERE username = ? AND password = ?"
    result = @db.select_sql(sql, [username, password])

    if result.any?
      level = username.downcase == "admin" ? "Администратор" : "Пользователь"
      puts "Успешный вход! Ваш уровень: #{level}"
    else
      puts "Ошибка: Неверный логин или пароль!"
    end
  end
end

db_path = "C:/dev/Ruby/App/db.db" 
db = ConnectDB.new(db_path)
app = UserAuthApp.new(db)
app.run