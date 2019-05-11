require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table

    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table

    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)

  end

  def save

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end

  def update

    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map {|data_base_row| self.new_from_db(data_base_row)}[0]
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.new_from_db(row)
    
    stu = self.new
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
    
  end

  def self.create(name, grade)

    student = Student.new(name, grade)
    student.save
    student

  end




end
