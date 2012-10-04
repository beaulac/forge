Factory.define :gallery do |f|
  f.sequence(:title) { |n| "Gallery #{n}"}
end