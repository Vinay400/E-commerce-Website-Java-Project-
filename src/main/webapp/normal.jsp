<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Product"%>
<%@page import="com.learn.mycart.entities.Order"%>
<%@page import="com.learn.mycart.dao.OrderDao"%>
<%@page import="com.learn.mycart.dao.ProductDao"%>
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
    
    // Get real-time data from database
    OrderDao orderDao = new OrderDao(FactoryProvider.getFactory());
    double totalSpent = orderDao.getTotalSpentByUser(user.getUserId());
    int totalOrders = orderDao.getOrderCountByUser(user.getUserId());
    
    // Get wishlist and cart items from localStorage using JavaScript
    
    // Get recent orders
    List<Order> recentOrders = orderDao.getRecentOrdersByUser(user.getUserId(), 5); // Get last 5 orders
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Dashboard - MyCart</title>
        
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
                transition: transform 0.3s;
            }
            
            .card:hover {
                transform: translateY(-5px);
            }
            
            .stats-card {
                border-left: 4px solid var(--primary-color);
            }
            
            .stats-card.orders {
                border-left-color: var(--success-color);
            }
            
            .stats-card.wishlist {
                border-left-color: #f6c23e;
            }
            
            .stats-card.cart {
                border-left-color: #e74a3b;
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
                            <a href="#" class="nav-link active">
                                <i class="fas fa-home me-2"></i> Dashboard
                            </a>
                            <a href="cart.jsp" class="nav-link">
                                <i class="fas fa-shopping-cart me-2"></i> My Cart
                            </a>
                            <a href="wishlist.jsp" class="nav-link">
                                <i class="fas fa-heart me-2"></i> Wishlist
                            </a>
                            <a href="#" class="nav-link">
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
                        <h2>Dashboard</h2>
                        <div class="user-info">
                            <i class="fas fa-user-circle me-2"></i>
                            Welcome, ${sessionScope.current-user.userName}
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card h-100">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col">
                                            <div class="text-xs text-uppercase mb-1 text-secondary">Total Spent</div>
                                            <div class="h5 mb-0 text-gray-800">$<%= String.format("%.2f", totalSpent) %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card orders h-100">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col">
                                            <div class="text-xs text-uppercase mb-1 text-secondary">Orders</div>
                                            <div class="h5 mb-0 text-gray-800"><%= totalOrders %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-shopping-bag fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card wishlist h-100">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col">
                                            <div class="text-xs text-uppercase mb-1 text-secondary">Wishlist</div>
                                            <div class="h5 mb-0 text-gray-800"><span id="wishlist-count">0</span> items</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-heart fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card cart h-100">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col">
                                            <div class="text-xs text-uppercase mb-1 text-secondary">Cart</div>
                                            <div class="h5 mb-0 text-gray-800"><span id="cart-count">0</span> items</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders -->
                    <div class="card mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Orders</h6>
                            <a href="#" class="btn btn-sm btn-primary">View All</a>
                        </div>
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
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Order order : recentOrders) { %>
                                        <tr>
                                            <td>#ORD-<%= order.getOrderId() %></td>
                                            <td><%= dateFormat.format(order.getOrderDate()) %></td>
                                            <td><%= order.getItems() != null && !order.getItems().isEmpty() ? order.getItems().split(",").length : 0 %> items</td>
                                            <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                                            <td>
                                                <% 
                                                String badgeClass = "bg-info";
                                                if(order.getStatus().equalsIgnoreCase("delivered")) {
                                                    badgeClass = "bg-success";
                                                } else if(order.getStatus().equalsIgnoreCase("in transit")) {
                                                    badgeClass = "bg-warning";
                                                }
                                                %>
                                                <span class="badge <%= badgeClass %>"><%= order.getStatus() %></span>
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
        
        <!-- Custom JavaScript for real-time cart and wishlist count -->
        <script>
            function updateDashboardCounts() {
                // Update cart count
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                document.getElementById('cart-count').textContent = cart.length;
                
                // Update wishlist count
                let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
                document.getElementById('wishlist-count').textContent = wishlist.length;
            }
            
            // Update counts when page loads
            document.addEventListener('DOMContentLoaded', updateDashboardCounts);
            
            // Update counts when storage changes
            window.addEventListener('storage', updateDashboardCounts);
        </script>
    </body>
</html>
