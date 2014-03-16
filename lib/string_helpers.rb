class StringHelpers
  def self.slugify(str)
    str.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
  end
end
