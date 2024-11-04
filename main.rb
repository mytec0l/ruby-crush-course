require 'date'

class Student
  attr_reader :name, :surname, :date_of_birth
  
  @@students = []
  
  def initialize(name, surname, date_of_birth)
    @name = name
    @surname = surname
    @date_of_birth = date_of_birth.is_a?(Date) ? date_of_birth : Date.parse(date_of_birth)
    validate_date_of_birth
    raise ArgumentError, "Student already exists" if self.class.student_exists?(self)
  end
  
  def self.students
    @@students
  end
  
  def calculate_age
    today = Date.today
    age = today.year - @date_of_birth.year
    age -= 1 if today < Date.new(today.year, @date_of_birth.month, @date_of_birth.day)
    age
  end
  
  def self.add_student(name, surname, date_of_birth)
    student = new(name, surname, date_of_birth)
    @@students << student
    student
  end
  
  def self.remove_student(name, surname, date_of_birth)
    date = date_of_birth.is_a?(Date) ? date_of_birth : Date.parse(date_of_birth)
    student = @@students.find do |s| 
      s.name == name && 
      s.surname == surname && 
      s.date_of_birth == date
    end
    @@students.delete(student) if student
  end
  
  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end
  
  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def self.clear_students
    @@students = []
  end
  
  private
  
  def validate_date_of_birth
    if @date_of_birth > Date.today
      raise ArgumentError, "Date of birth cannot be in the future"
    end
  end
  
  def self.student_exists?(student)
    @@students.any? do |existing_student|
      existing_student.name == student.name &&
      existing_student.surname == student.surname &&
      existing_student.date_of_birth == student.date_of_birth
    end
  end
end