module SeedHelper
  def log_section(title)
    puts "=" * 50
    puts title.center(50)
    puts "=" * 50
    yield
    puts "=" * 50
    puts "End #{title}".center(50)
    puts "=" * 50
    puts
  end

  def csv_path(filename)
    Rails.root.join('db', 'seeds', 'fixtures', "#{filename}.csv")
  end

  def parse_boolean(value)
    value == "true"
  end
end
