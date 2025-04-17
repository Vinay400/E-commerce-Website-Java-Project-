<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.entities.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.learn.mycart.dao.ProductDao"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Cart - MyCart</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            body {
                background-color: #f8f9fc;
                font-family: 'Nunito', sans-serif;
            }
            
            .cart-item {
                transition: all 0.3s;
            }
            
            .cart-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,.15);
            }
            
            .remove-item {
                cursor: pointer;
                transition: all 0.3s;
            }
            
            .remove-item:hover {
                color: #e74a3b;
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <%@include file="components/navbar.jsp" %>
        
        <div class="container mt-4">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">
                                <i class="fas fa-shopping-cart me-2"></i>My Cart
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="cart-items" id="cart-items">
                                <!-- Cart items will be loaded here dynamically -->
                            </div>
                            
                            <div class="cart-summary mt-4">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="alert alert-info">
                                            <h5>Cart Summary</h5>
                                            <p class="mb-0">Total Items: <span id="total-items">0</span></p>
                                            <p class="mb-0">Total Price: $<span id="total-price">0.00</span></p>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <button class="btn btn-success btn-lg" onclick="checkout()">
                                            <i class="fas fa-credit-card me-2"></i>Checkout
                                        </button>
                                    </div>
                                </div>
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
        
        <!-- Custom JavaScript -->
        <script>
            // Load cart items when page loads
            document.addEventListener('DOMContentLoaded', loadCartItems);
            
            function loadCartItems() {
                // Get cart items from localStorage
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                let cartItemsHtml = '';
                let totalPrice = 0;
                
                if (cart.length === 0) {
                    cartItemsHtml = '<div class="alert alert-info">Your cart is empty</div>';
                } else {
                    cart.forEach(item => {
                        totalPrice += item.price * item.quantity;
                        cartItemsHtml += `
                            <div class="cart-item card mb-3">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <img src="img/products/${item.image}" class="img-fluid" alt="${item.name}">
                                        </div>
                                        <div class="col-md-4">
                                            <h5 class="card-title">${item.name}</h5>
                                            <p class="card-text text-muted">${item.description}</p>
                                        </div>
                                        <div class="col-md-2">
                                            $${item.price.toFixed(2)}
                                        </div>
                                        <div class="col-md-2">
                                            <div class="input-group">
                                                <button class="btn btn-outline-secondary" onclick="updateQuantity(${item.id}, -1)">-</button>
                                                <input type="text" class="form-control text-center" value="${item.quantity}" readonly>
                                                <button class="btn btn-outline-secondary" onclick="updateQuantity(${item.id}, 1)">+</button>
                                            </div>
                                        </div>
                                        <div class="col-md-1">
                                            $${(item.price * item.quantity).toFixed(2)}
                                        </div>
                                        <div class="col-md-1 text-end">
                                            <i class="fas fa-trash remove-item" onclick="removeItem(${item.id})"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                }
                
                document.getElementById('cart-items').innerHTML = cartItemsHtml;
                document.getElementById('total-items').textContent = cart.length;
                document.getElementById('total-price').textContent = totalPrice.toFixed(2);
            }
            
            function updateQuantity(itemId, change) {
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                const itemIndex = cart.findIndex(item => item.id === itemId);
                
                if (itemIndex !== -1) {
                    cart[itemIndex].quantity = Math.max(1, cart[itemIndex].quantity + change);
                    localStorage.setItem('cart', JSON.stringify(cart));
                    loadCartItems();
                }
            }
            
            function removeItem(itemId) {
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                cart = cart.filter(item => item.id !== itemId);
                localStorage.setItem('cart', JSON.stringify(cart));
                loadCartItems();
            }
            
            function checkout() {
                // Implement checkout functionality
                alert('Checkout functionality will be implemented here');
            }
        </script>
    </body>
</html> 