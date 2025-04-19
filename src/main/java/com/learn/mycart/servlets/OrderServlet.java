package com.learn.mycart.servlets;

import com.google.gson.Gson;
import com.learn.mycart.dao.ProductDao;
import com.learn.mycart.entities.Order;
import com.learn.mycart.entities.OrderItem;
import com.learn.mycart.entities.Product;
import com.learn.mycart.entities.ShippingAddress;
import com.learn.mycart.entities.User;
import com.learn.mycart.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

    private final Gson gson = new Gson();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get the JSON data from request body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            // Parse the JSON data
            JSONObject jsonOrder = new JSONObject(sb.toString());
            
            // Get the user session
            HttpSession httpSession = request.getSession();
            User user = (User) httpSession.getAttribute("current-user");
            
            if (user == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "User not logged in");
                out.println(gson.toJson(errorResponse));
                return;
            }
            
            // Create order in database
            Session hibernateSession = FactoryProvider.getFactory().openSession();
            Transaction tx = hibernateSession.beginTransaction();
            
            try {
                // Create new order
                Order order = new Order(user);
                order.setOrderId("ORD" + System.currentTimeMillis());
                
                // Set shipping details
                JSONObject shippingDetails = jsonOrder.getJSONObject("shippingDetails");
                ShippingAddress shippingAddress = new ShippingAddress(
                    shippingDetails.getString("firstName"),
                    shippingDetails.getString("lastName"),
                    shippingDetails.getString("email"),
                    shippingDetails.getString("phone"),
                    shippingDetails.getString("address"),
                    shippingDetails.getString("city"),
                    shippingDetails.getString("state"),
                    shippingDetails.getString("pincode")
                );
                order.setShippingAddress(shippingAddress);
                
                // Set payment method
                order.setPaymentMethod(shippingDetails.getString("paymentMethod"));
                
                // Add order items
                JSONArray items = jsonOrder.getJSONArray("items");
                ProductDao productDao = new ProductDao(FactoryProvider.getFactory());
                
                for (int i = 0; i < items.length(); i++) {
                    JSONObject item = items.getJSONObject(i);
                    Product product = productDao.getProductById(item.getInt("id"));
                    
                    if (product != null) {
                        OrderItem orderItem = new OrderItem(
                            product,
                            item.getInt("quantity"),
                            item.getDouble("price")
                        );
                        order.addItem(orderItem);
                    }
                }
                
                // Calculate totals
                order.calculateTotals();
                
                // Save order
                hibernateSession.save(order);
                tx.commit();
                
                Map<String, Object> successResponse = new HashMap<>();
                successResponse.put("success", true);
                successResponse.put("orderId", order.getOrderId());
                successResponse.put("message", "Order placed successfully");
                out.println(gson.toJson(successResponse));
                
            } catch (Exception e) {
                tx.rollback();
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Error processing order: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            } finally {
                hibernateSession.close();
            }
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Error processing request: " + e.getMessage());
            out.println(gson.toJson(errorResponse));
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

    @Override
    public String getServletInfo() {
        return "OrderServlet handles order processing";
    }
} 