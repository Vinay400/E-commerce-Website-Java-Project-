-- Insert Admin User
INSERT INTO User (user_name, user_email, user_password, user_phone, user_pic, user_address, user_type) 
VALUES ('Admin User', 'admin@mycart.com', 'admin123', '1234567890', 'default.jpg', '123 Admin Street', 'admin');

-- Insert Categories
INSERT INTO Category (categoryTitle, categoryDescription) VALUES
('Electronics', 'Electronic gadgets and devices'),
('Clothing', 'Fashion and apparel'),
('Books', 'Books and publications'),
('Home & Kitchen', 'Home and kitchen appliances');

-- Insert Products
INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) 
VALUES 
('Smartphone', 'Latest smartphone with advanced features', 'phone.jpg', 599.99, 10, 50, 1),
('Laptop', 'High-performance laptop', 'laptop.jpg', 999.99, 15, 30, 1),
('T-Shirt', 'Cotton T-shirt', 'tshirt.jpg', 29.99, 5, 100, 2),
('Jeans', 'Denim jeans', 'jeans.jpg', 49.99, 10, 75, 2),
('Java Programming', 'Learn Java programming', 'java-book.jpg', 39.99, 20, 25, 3),
('Coffee Maker', 'Automatic coffee maker', 'coffee-maker.jpg', 79.99, 12, 40, 4);

-- Insert Normal User
INSERT INTO User (user_name, user_email, user_password, user_phone, user_pic, user_address, user_type) 
VALUES ('John Doe', 'john@example.com', 'user123', '9876543210', 'default.jpg', '456 User Street', 'normal'); 