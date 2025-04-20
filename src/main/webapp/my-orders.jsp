<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Order"%>
<%@page import="com.learn.mycart.dao.OrderDao"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get all orders for the user
    OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
    List<Order> allOrders = orderDao.getRecentOrdersByUser(user.getUserId(), 100); // Get up to 100 orders
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Orders - MyCart</title>
        
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
            
            .sidebar {
                background: linear-gradient(180deg, var(--primary-color) 10%, #224abe 100%);
                min-height: 100vh;
                color: white;
            }
            
            .sidebar .nav-link {
                color: rgba(255,255,255,.8);
                padding: 1rem;
                margin: 0.2rem 0;
                border-radius: 0.35rem;
                transition: all 0.3s;
            }
            
            .sidebar .nav-link:hover {
                color: white;
                background-color: rgba(255,255,255,.1);
            }
            
            .sidebar .nav-link.active {
                background-color: rgba(255,255,255,.15);
                color: white;
            }
            
            .card {
                border: none;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,.15);
            }
            
            .order-card:hover {
                transform: translateY(-5px);
                transition: transform 0.3s ease;
            }
            
            .badge {
                font-size: 0.85em;
                padding: 0.5em 1em;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 sidebar p-0">
                    <div class="d-flex flex-column p-3">
                        <h4 class="text-center mb-4">MyCart</h4>
                        <div class="nav flex-column">
                            <a href="normal.jsp" class="nav-link">
                                <i class="fas fa-home me-2"></i> Dashboard
                            </a>
                            <a href="cart.jsp" class="nav-link">
                                <i class="fas fa-shopping-cart me-2"></i> My Cart
                            </a>
                            <a href="wishlist.jsp" class="nav-link">
                                <i class="fas fa-heart me-2"></i> Wishlist
                            </a>
                            <a href="my-orders.jsp" class="nav-link active">
                                <i class="fas fa-box me-2"></i> My Orders
                            </a>
                            <a href="#" class="nav-link">
                                <i class="fas fa-user me-2"></i> Profile
                            </a>
                            <a href="LogoutServlet" class="nav-link">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>My Orders</h2>
                        <div class="user-info">
                            <i class="fas fa-user-circle me-2"></i>
                            Welcome, ${sessionScope.current-user.userName}
                        </div>
                    </div>

                    <!-- Orders List -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Date</th>
                                            <th>Items</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th>Payment Method</th>
                                            <th>Shipping Address</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (allOrders != null && !allOrders.isEmpty()) { %>
                                            <% for(Order order : allOrders) { %>
                                                <tr class="order-card">
                                                    <td>#ORD-<%= order.getOrderId() %></td>
                                                    <td><%= dateFormat.format(order.getOrderDate()) %></td>
                                                    <td><%= order.getTotalItems() %> items</td>
                                                    <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                                                    <td>
                                                        <% 
                                                        String badgeClass = "bg-info";
                                                        if(order.getOrderStatus().equalsIgnoreCase("DELIVERED")) {
                                                            badgeClass = "bg-success";
                                                        } else if(order.getOrderStatus().equalsIgnoreCase("IN_TRANSIT")) {
                                                            badgeClass = "bg-warning";
                                                        } else if(order.getOrderStatus().equalsIgnoreCase("CANCELLED")) {
                                                            badgeClass = "bg-danger";
                                                        }
                                                        %>
                                                        <span class="badge <%= badgeClass %>"><%= order.getOrderStatus() %></span>
                                                    </td>
                                                    <td><%= order.getPaymentMethod() %></td>
                                                    <td>
                                                        <span class="text-truncate d-inline-block" style="max-width: 150px;" 
                                                              title="<%= order.getShippingAddress() %>">
                                                            <%= order.getShippingAddress() %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="order-details.jsp?orderId=<%= order.getOrderId() %>" 
                                                           class="btn btn-sm btn-primary">
                                                            <i class="fas fa-eye me-1"></i> View Details
                                                        </a>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        <% } else { %>
                                            <tr>
                                                <td colspan="8" class="text-center py-5">
                                                    <i class="fas fa-box-open fa-3x mb-3 text-muted"></i>
                                                    <h5 class="text-muted">No orders found</h5>
                                                    <a href="index.jsp" class="btn btn-primary mt-3">
                                                        <i class="fas fa-shopping-cart me-2"></i>Start Shopping
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
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