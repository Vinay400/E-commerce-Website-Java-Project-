package com.learn.mycart.servlets;

import com.learn.mycart.dao.OrderDao;
import com.learn.mycart.entities.Order;
import com.learn.mycart.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/cancel-order"})
public class CancelOrderServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            JSONObject jsonResponse = new JSONObject();
            
            try {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
                Order order = orderDao.getOrderById(orderId);
                
                if (order != null) {
                    order.setOrderStatus("CANCELLED");
                    orderDao.updateOrder(order);
                    
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Order cancelled successfully");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Order not found");
                }
            } catch (NumberFormatException e) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid order ID format");
            } catch (Exception e) {
                e.printStackTrace();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Error cancelling order: " + e.getMessage());
            }
            
            out.println(jsonResponse.toString());
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
        return "Servlet for cancelling orders";
    }
} 