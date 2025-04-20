-- First, let's see what categories already exist
SELECT MAX(categoryId) INTO @max_id FROM Category;

-- Add Categories with new IDs
INSERT INTO Category (categoryTitle, categoryDescription) VALUES
('Fashion', 'Clothing and accessories for all styles'),
('Electronics', 'Latest gadgets and electronic devices'),
('Books', 'Educational and learning materials'),
('Mobile Phones', 'Smartphones and accessories'),
('Home Appliances', 'Kitchen and home electronic appliances');

-- Get the IDs of our newly inserted categories
SET @fashion_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Fashion' ORDER BY categoryId DESC LIMIT 1);
SET @electronics_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Electronics' ORDER BY categoryId DESC LIMIT 1);
SET @books_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Books' ORDER BY categoryId DESC LIMIT 1);
SET @mobile_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Mobile Phones' ORDER BY categoryId DESC LIMIT 1);
SET @appliances_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Home Appliances' ORDER BY categoryId DESC LIMIT 1);

-- Add Products using the retrieved category IDs
INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('Black Relaxed Fit Jeans', 'Comfortable black jeans with relaxed fit, perfect for casual wear', 'black_jeans.jpg', 1499.00, 10, 50, @fashion_id);

INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('AGARO Coffee Maker', 'Premium espresso coffee maker with pressure gauge and milk frother', 'coffee_maker.jpg', 8999.00, 15, 20, @appliances_id);

INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('Programming with Java by E Balagurusamy', 'Comprehensive guide to Java programming language', 'java_book.jpg', 599.00, 5, 100, @books_id);

INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('Realme P3 Pro 5G', '5G smartphone with 50MP camera, 8GB RAM, 128GB storage', 'realme_p3_pro.jpg', 24999.00, 12, 30, @mobile_id);

INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('No Rules To Enjoy T-Shirt', 'Stylish cotton t-shirt with motivational quote print', 'tshirt.jpg', 699.00, 20, 75, @fashion_id);

INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES ('Refurbished Laptop', 'Certified refurbished laptop with warranty', 'laptop.jpg', 29999.00, 25, 15, @electronics_id); 