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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class CheckoutServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get JSON data from request
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
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
            Order order = new Order(user);
            
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
            
            // Add items to order
            JSONArray items = jsonData.getJSONArray("items");
            ProductDao productDao = new ProductDao(FactoryProvider.getFactory());
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                Product product = productDao.getProductById((int)item.getLong("productId"));
                
                if (product != null) {
                    OrderItem orderItem = new OrderItem(
                            product,
                            item.getInt("productQuantity"),
                            item.getDouble("productPrice")
                    );
                    order.addItem(orderItem);
                }
            }
            
            // Set initial order status
            order.setStatus("PENDING");
            
            // Save order to database
            OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
            orderDao.saveOrder(order);
            
            // Return success response
            JSONObject successJson = new JSONObject();
            successJson.put("success", true);
            successJson.put("orderId", order.getOrderId());
            out.println(successJson.toString());
            
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