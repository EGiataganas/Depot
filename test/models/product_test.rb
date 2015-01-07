require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
  	product = Product.new(title: "any",
					  						  description: "kdsjfkl",
					  						  price: 1,
					  						  image_url: image_url)
  end

  test "image url" do
  	ok = %w{ fe.jpg fe.png fe.gif FE.JPG FEGH.GIf JSGK.PnG http://a.b.d/s/dd/ferD.gif}
  	bad = %w{ jdshkjhfs.gif.lk http://lhdsf.lkfds/more}

  	ok.each {|name| assert new_product(name).valid?, "#{name} should be valid"}
  	bad.each {|name| assert new_product(name).invalid?, "#{name} should not be valid"}
  end

  test "product is not valid without a unique title" do
  	product = Product.new(title: products(:ruby).title,
  						  					description: "yyy",
  						  					price: 1,
  						  					image_url: "fred.gif")
  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy", 
                          price: 1, 
                          image_url: "fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end

end
