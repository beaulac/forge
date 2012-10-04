Factory.define :post do |f|
  f.sequence(:title)  { |n| "This is post #{n}" }
  f.content           "Lorem ipsum blah blah blah"
  f.excerpt           "Lorem"
end