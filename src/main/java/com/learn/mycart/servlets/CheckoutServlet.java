package com.learn.mycart.servlets;

import com.learn.mycart.entities.Order;
import com.learn.mycart.entities.User;
import com.learn.mycart.entities.OrderItem;
import com.learn.mycart.entities.Product;
import com.learn.mycart.dao.OrderDao;
import com.learn.mycart.dao.ProductDao;
import com.learn.mycart.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import org.json.JSONArray;

public class CheckoutServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("current-user");

            if (user == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "User not logged in");
                out.println(jsonResponse);
                return;
            }

            // Read request body
            StringBuilder sb = new StringBuilder();
            String s;
            while ((s = request.getReader().readLine()) != null) {
                sb.append(s);
            }
            JSONObject orderData = new JSONObject(sb.toString());

            // Create order
            Order order = new Order();
            order.setUser(user);
            order.setOrderDate(new Date());
            order.setTotal(orderData.getDouble("total"));
            
            // Create order items
            JSONArray items = orderData.getJSONArray("items");
            ProductDao productDao = new ProductDao(FactoryProvider.getFactory());
            
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                Product product = productDao.getProductById(item.getInt("id"));
                
                if (product != null) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setProduct(product);
                    orderItem.setQuantity(item.getInt("quantity"));
                    orderItem.setPrice(item.getDouble("price"));
                    order.addItem(orderItem);
                }
            }
            
            order.setStatus("pending");

            // Save order
            OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
            boolean success = orderDao.saveOrder(order);

            if (success) {
                jsonResponse.put("success", true);
                jsonResponse.put("orderId", order.getOrderId());
                jsonResponse.put("message", "Order placed successfully");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to place order");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error processing order: " + e.getMessage());
        }

        out.println(jsonResponse);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 