-- First delete all records
DELETE FROM Product;
DELETE FROM Category;

-- Insert the main categories
INSERT INTO Category (categoryTitle, categoryDescription) VALUES
('Electronics', 'Latest gadgets and electronic devices'),
('Fashion', 'Clothing and accessories for all styles'),
('Books', 'Educational and learning materials');

-- Get the category IDs
SET @electronics_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Electronics');
SET @fashion_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Fashion');
SET @books_id = (SELECT categoryId FROM Category WHERE categoryTitle = 'Books');

-- Insert the 6 specific products
INSERT INTO Product (pName, pDesc, pPhoto, pPrice, pDiscount, pQuantity, category_categoryId) VALUES
('Refurbished Laptop', 'High-performance refurbished laptop with warranty', 'laptop.jpg', 45000, 15, 5, @electronics_id),
('Designer T-Shirt', 'Premium cotton designer t-shirt', 'tshirt.jpg', 1999, 10, 20, @fashion_id),
('Wireless Earbuds', 'True wireless earbuds with noise cancellation', 'earbuds.jpg', 8999, 5, 15, @electronics_id),
('Java Programming Book', 'Complete guide to Java programming', 'java_book.jpg', 799, 5, 10, @books_id),
('Smart Watch', 'Fitness tracking smart watch', 'smartwatch.jpg', 12999, 20, 8, @electronics_id),
('Running Shoes', 'Professional running shoes', 'shoes.jpg', 3999, 10, 12, @fashion_id);

-- Show the final data
SELECT 'Categories after cleanup:' as Message;
SELECT * FROM Category ORDER BY categoryId;

SELECT 'Products after cleanup:' as Message;
SELECT p.*, c.categoryTitle 
FROM Product p 
JOIN Category c ON p.category_categoryId = c.categoryId 
ORDER BY p.pId; 