require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"
      login_user
      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end
    describe 'When I am not logged in and visit cart' do
      it 'I get prompted to log in or register' do
        visit "/cart"

        click_on "Checkout"

        expect(page).to have_content("You must log in or register to complete checkout")
        expect(page).to have_link("Register")
        expect(page).to have_link("Log in")

        click_link "Register"
        expect(current_path).to eq("/register")
      end
    end
    it 'A registered user can checkout' do
      @user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit '/login'

      fill_in :email, with:"p.fiona12@castle.co"
      fill_in :password, with:"boom"

      click_button "Log In"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
      fill_in :name, with: "Shrek"
      fill_in :address, with:"123 swamp city"
      fill_in :city, with: "Duloc City"
      fill_in :state, with: "Duloc State"
      fill_in :zip, with: 10001

      click_button 'Create Order'

      order = Order.last

      expect(current_path).to eq("/orders/#{order.id}")

      expect(order.status).to eq("pending")
      expect(page).to have_content("Your order has been created")
      expect(page).to have_content("#{order.name}")
      expect(page).to have_content("Cart: 0")

    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
  describe 'When admin tried to access cart or merchant pages' do
    it 'there is a 404 error message' do
      admin = User.create(name: "Lord Farquaad",
                          address: "123 Castle Lane",
                          city: "Duloc City",
                          state: "Duloc State",
                          zip: 10001,
                          email: "lord.farquaad@castle.gov",
                          password: "Password",
                          role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

end
