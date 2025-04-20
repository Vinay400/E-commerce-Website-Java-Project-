<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Order"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%@page import="org.hibernate.Session"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
    
    String orderId = request.getParameter("orderId");
    if (orderId == null || orderId.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Confirmation - MyCart</title>
        <%@include file="components/common_css_js.jsp" %>
        <style>
            .order-confirmation {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
            }
            .success-icon {
                font-size: 64px;
                color: #28a745;
            }
            .order-details {
                margin-top: 30px;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
            }
            .detail-row {
                margin-bottom: 15px;
            }
            .redirect-message {
                margin-top: 20px;
                color: #666;
            }
        </style>
    </head>
    <body>
        <%@include file="components/navbar.jsp" %>
        
        <div class="container mt-4">
            <div class="order-confirmation">
                <div class="text-center">
                    <i class="fa fa-check-circle success-icon"></i>
                    <h2 class="mt-3">Thank You for Your Order!</h2>
                    <p class="lead">Your order has been successfully placed.</p>
                </div>
                
                <div class="order-details">
                    <h4>Order Details</h4>
                    <div class="detail-row">
                        <strong>Order ID:</strong> <%= orderId %>
                    </div>
                    <div class="detail-row">
                        <strong>Order Date:</strong> <%= new java.util.Date() %>
                    </div>
                    <div class="detail-row">
                        <strong>Shipping Address:</strong>
                        <div class="ml-3">
                            <%= user.getUserName() %><br>
                            <span id="shippingAddress"></span>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <a href="index.jsp" class="btn btn-primary">Continue Shopping</a>
                    <p class="redirect-message">Redirecting to home page in <span id="countdown">5</span> seconds...</p>
                </div>
            </div>
        </div>
        
        <script>
            // Clear the cart after successful order
            localStorage.removeItem('cart');
            // Update cart count
            updateCart();
            
            // Display shipping address from localStorage
            const orderDetails = JSON.parse(localStorage.getItem('lastOrder') || '{}');
            if (orderDetails.shippingAddress) {
                document.getElementById('shippingAddress').innerHTML = 
                    orderDetails.shippingAddress.address + '<br>' +
                    orderDetails.shippingAddress.city + ', ' +
                    orderDetails.shippingAddress.state + ' - ' +
                    orderDetails.shippingAddress.pincode;
            }
            
            // Countdown timer and redirect
            let countdown = 5;
            const countdownElement = document.getElementById('countdown');
            
            const timer = setInterval(() => {
                countdown--;
                countdownElement.textContent = countdown;
                
                if (countdown <= 0) {
                    clearInterval(timer);
                    window.location.href = 'index.jsp';
                }
            }, 1000);
        </script>
    </body>
</html> 