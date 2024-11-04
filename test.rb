require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative 'main'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new,
  Minitest::Reporters::HtmlReporter.new(reports_dir: "test/reports")
]

class StudentTest < Minitest::Test
  def setup
    Student.clear_students
  end

  def test_create_student
    student = Student.add_student("Ivan", "Ivanov", "2000-01-01")
    assert_equal "Ivan", student.name
    assert_equal "Ivanov", student.surname
    assert_equal Date.parse("2000-01-01"), student.date_of_birth
  end

  def test_prevent_future_date_of_birth
    assert_raises ArgumentError do
      Student.add_student("Future", "Student", "2025-01-01")
    end
  end

  def test_prevent_duplicate_students
    Student.add_student("Ivan", "Ivanov", "2000-01-01")
    assert_raises ArgumentError do
      Student.add_student("Ivan", "Ivanov", "2000-01-01")
    end
  end

  def test_calculate_age
    student = Student.add_student("Ivan", "Ivanov", "2000-01-01")
    expected_age = ((Date.today - Date.parse("2000-01-01"))/365).floor
    assert_equal expected_age, student.calculate_age
  end

  def test_get_students_by_name
    Student.add_student("Ivan", "Ivanov", "2000-01-01")
    Student.add_student("Ivan", "Petrov", "2001-05-15")
    Student.add_student("Petr", "Sidorov", "1999-12-31")
    
    ivans = Student.get_students_by_name("Ivan")
    assert_equal 2, ivans.length
    assert ivans.all? { |s| s.name == "Ivan" }
  end

  def test_remove_student
    Student.add_student("Ivan", "Ivanov", "2000-01-01")
    assert_equal 1, Student.students.length
    
    Student.remove_student("Ivan", "Ivanov", "2000-01-01")
    assert_empty Student.students
  end

  def test_get_students_by_age
    current_year = Date.today.year
    birth_year = current_year - 20
    
    Student.add_student("Young", "Student", "#{birth_year}-01-01")
    students_20 = Student.get_students_by_age(20)
    
    assert_equal 1, students_20.length
    assert_equal 20, students_20.first.calculate_age
  end
end