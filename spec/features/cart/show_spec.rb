require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 2)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 2)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it 'I can increase and decrease the quantity of items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            click_on "Add 1 to Quantity"
            expect(page).to have_content("2")
            click_on "Remove 1 from Quantity"
            expect(page).to have_content("1")
          end
        end
      end

      it 'I cannot increase the quantity of items past the inventory' do
        visit '/cart'

          within "#cart-item-#{@paper.id}" do
            click_on "Add 1 to Quantity"
            expect(page).to have_content("2")
            click_on "Add 1 to Quantity"
          end
        expect(page).to have_content("No More Can Be Ordered At This Time")
      end

      it 'If I decrement the quantity to 0 the item is immediately removed from my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            click_on "Remove 1 from Quantity"
          end
          save_and_open_page
          expect(page).to_not have_css("#cart-item-#{item.id}")
        end
      end
    end

  end
  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end

    end
  end
end

# User Story 23, Adding Item Quantity to Cart
#
# As a visitor
# When I have items in my cart
# And I visit my cart
# Next to each item in my cart
# I see a button or link to increment the count of items I want to purchase
# I cannot increment the count beyond the item's inventory size

# User Story 24, Decreasing Item Quantity from Cart
#
# As a visitor
# When I have items in my cart
# And I visit my cart
# Next to each item in my cart
# I see a button or link to decrement the count of items I want to purchase
# If I decrement the count to 0 the item is immediately removed from my cart
