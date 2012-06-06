# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

languages = Language.create([{ name: 'English' }, { name: 'Spanish' }, { name: 'French' }, { name: 'German' }, { name: 'Swahili' }])
publishers = Publisher.create([{ name: 'Sub-saharan' }, { name: 'D&G' }, { name: 'FrenchLoveStory' }])
sclasses = Sclass.create([{name: 'Ad2007b'}, {name: 'Ad2007a'}, {name: 'Ad2008a'}, {name: 'Ad2006a'}])
schools = School.create([{name: 'Adeiso Primary'}, {name: 'Adeiso JH'}, {name: 'Adeiso SH'}, {name: 'Kade Primary'}])

origins = Origin.create([{name: 'Ghana'}, {name: 'Kenya'}, {name: 'Uganda'}, {name: 'South Africa'}, {name: 'Ethiopia'}, {name: 'Egypt'}])
models = Model.create([{name: 'Individual'}, {name: 'Classroom'}, {name: 'Library'}])
continents = Continent.create([{name: 'Africa'}, {name: 'South America'}, {name: 'Asia'}, {name: 'Europe'}])


