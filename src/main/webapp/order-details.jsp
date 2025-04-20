<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Order"%>
<%@page import="com.learn.mycart.entities.OrderItem"%>
<%@page import="com.learn.mycart.dao.OrderDao"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get order ID from request parameter
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
        response.sendRedirect("normal.jsp");
        return;
    }
    
    int orderId = Integer.parseInt(orderIdStr);
    OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
    Order order = orderDao.getOrderById(orderId);
    
    // Verify order belongs to current user
    if (order == null || order.getUser().getUserId() != user.getUserId()) {
        response.sendRedirect("normal.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Details - MyCart</title>
        <%@include file="components/common_css_js.jsp"%>
        <style>
            .order-details-card {
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .status-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 500;
            }
            .status-PENDING {
                background-color: #ffd700;
                color: #000;
            }
            .status-COMPLETED {
                background-color: #28a745;
                color: #fff;
            }
            .status-CANCELLED {
                background-color: #dc3545;
                color: #fff;
            }
            .product-img {
                max-width: 80px;
                height: auto;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <%@include file="components/navbar.jsp"%>
        
        <div class="container py-4">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card order-details-card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Order #ORD-<%= order.getOrderId() %></h5>
                            <span class="status-badge status-<%= order.getOrderStatus() %>">
                                <%= order.getOrderStatus() %>
                            </span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h6 class="text-muted">Order Date</h6>
                                    <p><%= dateFormat.format(order.getOrderDate()) %></p>
                                    
                                    <h6 class="text-muted mt-3">Payment Method</h6>
                                    <p><%= order.getPaymentMethod() %></p>
                                    
                                    <% if (order.getPaymentId() != null && !order.getPaymentId().isEmpty()) { %>
                                        <h6 class="text-muted mt-3">Payment ID</h6>
                                        <p><%= order.getPaymentId() %></p>
                                    <% } %>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Shipping Address</h6>
                                    <p>
                                        <%= order.getShippingAddress() %><br>
                                        <%= order.getShippingCity() %>, <%= order.getShippingState() %><br>
                                        <%= order.getShippingZip() %>
                                    </p>
                                </div>
                            </div>
                            
                            <h6 class="mb-3">Order Items</h6>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th class="text-end">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (OrderItem item : order.getOrderItems()) { %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="img/products/<%= item.getProduct().getpPhoto() %>" 
                                                             class="product-img me-3" 
                                                             alt="<%= item.getProduct().getpName() %>">
                                                        <div>
                                                            <h6 class="mb-0"><%= item.getProduct().getpName() %></h6>
                                                            <small class="text-muted"><%= item.getProduct().getCategory().getCategoryTitle() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>₹<%= String.format("%.2f", item.getPrice()) %></td>
                                                <td><%= item.getQuantity() %></td>
                                                <td class="text-end">₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                            <td class="text-end">₹<%= String.format("%.2f", order.getTotalAmount()) %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Shipping:</strong></td>
                                            <td class="text-end">Free</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                            <td class="text-end"><strong>₹<%= String.format("%.2f", order.getTotalAmount()) %></strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer bg-white">
                            <a href="normal.jsp" class="btn btn-secondary">Back to Dashboard</a>
                            <% if (order.getOrderStatus().equals("PENDING")) { %>
                                <button class="btn btn-danger float-end" onclick="cancelOrder(<%= order.getOrderId() %>)">Cancel Order</button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function cancelOrder(orderId) {
                if (confirm('Are you sure you want to cancel this order?')) {
                    fetch('CancelOrderServlet?orderId=' + orderId, {
                        method: 'POST'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Failed to cancel order: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('An error occurred while canceling the order');
                    });
                }
            }
        </script>
    </body>
</html> 