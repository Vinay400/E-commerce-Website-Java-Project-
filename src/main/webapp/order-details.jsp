<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Order"%>
<%@page import="com.learn.mycart.entities.OrderItem"%>
<%@page import="com.learn.mycart.dao.OrderDao"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
    
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
        session.setAttribute("message", "Order ID is required!");
        response.sendRedirect("my-orders.jsp");
        return;
    }
    
    Long orderId = Long.parseLong(orderIdStr);
    OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
    Order order = orderDao.getOrderById(orderId);
    
    // Verify order belongs to current user
    if (order == null || order.getUser().getUserId() != user.getUserId()) {
        session.setAttribute("message", "Order not found or unauthorized access!");
        response.sendRedirect("my-orders.jsp");
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
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
            }
            
            body {
                background-color: #f8f9fc;
                font-family: 'Nunito', sans-serif;
            }
            
            .card {
                border: none;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,.15);
            }
            
            .status-badge {
                padding: 0.5em 1em;
                border-radius: 50px;
                font-size: 0.9em;
                font-weight: 500;
            }
            
            .status-completed {
                background-color: #d4edda;
                color: #155724;
            }
            
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            
            .status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .product-img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 0.35rem;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>Order Details</h2>
                                <a href="my-orders.jsp" class="btn btn-outline-primary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Orders
                                </a>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted">Order ID</h6>
                                    <p>#ORD-<%= order.getOrderId() %></p>
                                    
                                    <h6 class="text-muted mt-3">Order Date</h6>
                                    <p><%= dateFormat.format(order.getOrderDate()) %></p>
                                    
                                    <h6 class="text-muted mt-3">Status</h6>
                                    <p>
                                        <span class="status-badge status-<%= order.getOrderStatus().toLowerCase() %>">
                                            <%= order.getOrderStatus() %>
                                        </span>
                                    </p>
                                    
                                    <h6 class="text-muted mt-3">Payment Method</h6>
                                    <p><%= order.getPaymentMethod() %></p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Shipping Address</h6>
                                    <p><%= order.getShippingAddress() %></p>
                                </div>
                            </div>
                            
                            <div class="table-responsive mt-4">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (OrderItem item : order.getItems()) { %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="img/products/<%= item.getProduct().getpPhoto() %>" 
                                                             alt="<%= item.getProduct().getpName() %>" 
                                                             class="product-img me-3">
                                                        <div>
                                                            <h6 class="mb-0"><%= item.getProduct().getpName() %></h6>
                                                            <small class="text-muted"><%= item.getProduct().getpDesc() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>₹<%= item.getProduct().getPriceAfterApplyingDiscount() %></td>
                                                <td><%= item.getQuantity() %></td>
                                                <td>₹<%= item.getSubtotal() %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                            <td><strong>₹<%= String.format("%.2f", order.getTotalAmount()) %></strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
        <!-- Font Awesome -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    </body>
</html> 