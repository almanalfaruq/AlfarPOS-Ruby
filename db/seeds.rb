# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name: "Admin", username: "admin", phone: "085647442276", no_ktp: "9182981928918", email: "admin@tokoalfar.com", password: "Admin123!", password_confirmation: "Admin123!")
user.add_role :admin

user = User.create(name: "Cashier", username: "cashier", phone: "081225812599", no_ktp: "918298128781", email: "cashier@tokoalfar.com", password: "cashier123", password_confirmation: "cashier123")
user.add_role :cashier
