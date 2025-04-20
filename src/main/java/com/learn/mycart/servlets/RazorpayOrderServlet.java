package com.learn.mycart.servlets;

import com.learn.mycart.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import java.net.URL;
import java.net.HttpURLConnection;
import java.io.OutputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Base64;

public class RazorpayOrderServlet extends HttpServlet {
    private static final String RAZORPAY_KEY_ID = "rzp_test_On67aDeEYAAIps";
    private static final String RAZORPAY_KEY_SECRET = "o5C4fbsGhe9ekb0IvH4EZy0Y";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("current-user");
            
            if (user == null) {
                JSONObject json = new JSONObject();
                json.put("status", "error");
                json.put("message", "User not logged in");
                out.println(json.toString());
                return;
            }
            
            // Get amount from request and convert to paise
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            JSONObject requestData = new JSONObject(sb.toString());
            double amount = requestData.getDouble("amount");
            int amountInPaise = (int)(amount * 100); // Convert to paise
            
            // Create order in Razorpay
            String orderId = createRazorpayOrder(amountInPaise);
            
            JSONObject json = new JSONObject();
            json.put("status", "success");
            json.put("orderId", orderId);
            out.println(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject json = new JSONObject();
            json.put("status", "error");
            json.put("message", "Error creating order: " + e.getMessage());
            out.println(json.toString());
        }
    }
    
    private String createRazorpayOrder(int amountInPaise) throws IOException {
        String url = "https://api.razorpay.com/v1/orders";
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Basic " + 
            Base64.getEncoder().encodeToString((RAZORPAY_KEY_ID + ":" + RAZORPAY_KEY_SECRET).getBytes()));
        
        JSONObject requestBody = new JSONObject();
        requestBody.put("amount", amountInPaise);
        requestBody.put("currency", "INR");
        requestBody.put("receipt", "order_rcptid_" + System.currentTimeMillis());
        
        conn.setDoOutput(true);
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }
        
        JSONObject jsonResponse = new JSONObject(response.toString());
        return jsonResponse.getString("id");
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