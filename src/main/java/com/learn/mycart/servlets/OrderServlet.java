package com.learn.mycart.servlets;

import com.learn.mycart.dao.OrderDao;
import com.learn.mycart.dao.ProductDao;
import com.learn.mycart.entities.Order;
import com.learn.mycart.entities.OrderItem;
import com.learn.mycart.entities.Product;
import com.learn.mycart.entities.User;
import com.learn.mycart.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class OrderServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get the JSON data from request
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            // Parse JSON data
            JSONObject jsonData = new JSONObject(sb.toString());
            
            // Get user from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("current-user");
            
            if (user == null) {
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("message", "User not logged in");
                out.println(errorJson.toString());
                return;
            }
            
            // Create new order
            Order order = new Order();
            order.setUser(user);
            order.setOrderDate(new java.util.Date()); // Set current date/time
            
            // Set shipping address
            JSONObject shippingAddress = jsonData.getJSONObject("shippingAddress");
            String fullAddress = String.format("%s\n%s, %s - %s",
                    shippingAddress.getString("address"),
                    shippingAddress.getString("city"),
                    shippingAddress.getString("state"),
                    shippingAddress.getString("pincode"));
            order.setShippingAddress(fullAddress);
            
            // Set payment method
            order.setPaymentMethod(jsonData.getString("paymentMethod"));
            
            // Set initial status
            order.setStatus("PENDING");
            
            // Add items to order
            JSONArray items = jsonData.getJSONArray("items");
            ProductDao productDao = new ProductDao(FactoryProvider.getFactory());
            double totalAmount = 0.0;
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                int productId = item.getInt("productId");
                int quantity = item.getInt("productQuantity");
                double price = item.getDouble("productPrice");
                
                Product product = productDao.getProductById(productId);
                if (product != null) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setProduct(product);
                    orderItem.setQuantity(quantity);
                    orderItem.setPrice(price);
                    orderItem.setOrder(order);
                    order.getItems().add(orderItem);
                    totalAmount += price * quantity;
                }
            }
            
            // Set total amount
            order.setTotalAmount(totalAmount);
            
            // Save order to database
            OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
            boolean saved = orderDao.saveOrder(order);
            
            if (saved) {
                // Return success response
                JSONObject successJson = new JSONObject();
                successJson.put("success", true);
                successJson.put("orderId", order.getOrderId());
                successJson.put("message", "Order placed successfully");
                out.println(successJson.toString());
            } else {
                throw new Exception("Failed to save order");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorJson = new JSONObject();
            errorJson.put("success", false);
            errorJson.put("message", "Error processing order: " + e.getMessage());
            out.println(errorJson.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 