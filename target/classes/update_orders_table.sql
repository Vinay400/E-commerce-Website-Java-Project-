-- Disable safe update mode and foreign key checks temporarily
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;

-- Create the orders table with proper constraints
CREATE TABLE orders (
    orderId BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    shipping_address TEXT,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50),
    payment_method VARCHAR(50),
    total_amount DOUBLE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Create the order_items table
CREATE TABLE order_items (
    orderItemId INT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT,
    product_id INT,
    quantity INT NOT NULL,
    price DOUBLE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(orderId),
    FOREIGN KEY (product_id) REFERENCES product(pId)
);

-- Re-enable safe update mode and foreign key checks
SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1; 