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
        <title>Wishlist - MyCart</title>
        
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
            
            .wishlist-item {
                transition: all 0.3s;
            }
            
            .wishlist-item:hover {
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
            
            .add-to-cart {
                transition: all 0.3s;
            }
            
            .add-to-cart:hover {
                transform: scale(1.05);
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
                                <i class="fas fa-heart me-2"></i>My Wishlist
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="wishlist-items" id="wishlist-items">
                                <!-- Wishlist items will be loaded here dynamically -->
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
            // Load wishlist items when page loads
            document.addEventListener('DOMContentLoaded', loadWishlistItems);
            
            function loadWishlistItems() {
                // Get wishlist items from localStorage
                let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
                let wishlistItemsHtml = '';
                
                if (wishlist.length === 0) {
                    wishlistItemsHtml = '<div class="alert alert-info">Your wishlist is empty</div>';
                } else {
                    wishlist.forEach(item => {
                        wishlistItemsHtml += `
                            <div class="wishlist-item card mb-3">
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
                                        <div class="col-md-3">
                                            <button class="btn btn-primary add-to-cart" onclick="addToCart(${item.id})">
                                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                                            </button>
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
                
                document.getElementById('wishlist-items').innerHTML = wishlistItemsHtml;
            }
            
            function addToCart(itemId) {
                let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                
                const item = wishlist.find(item => item.id === itemId);
                if (item) {
                    // Add to cart
                    cart.push({...item, quantity: 1});
                    localStorage.setItem('cart', JSON.stringify(cart));
                    
                    // Remove from wishlist
                    removeItem(itemId);
                    
                    alert('Item added to cart!');
                }
            }
            
            function removeItem(itemId) {
                let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
                wishlist = wishlist.filter(item => item.id !== itemId);
                localStorage.setItem('wishlist', JSON.stringify(wishlist));
                loadWishlistItems();
            }
        </script>
    </body>
</html> 