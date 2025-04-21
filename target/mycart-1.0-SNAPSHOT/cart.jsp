<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart Page</title>
        <%@include file="components/common_css_js.jsp" %>
        <style>
            .quantity-controls {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            
            .quantity-controls .btn {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                line-height: 1.5;
                border-radius: 0.2rem;
                min-width: 32px;
            }
            
            .quantity-controls span {
                min-width: 30px;
                text-align: center;
                font-weight: 500;
            }
            
            .cart-body table {
                margin-bottom: 0;
            }
            
            .cart-body th {
                background-color: #f8f9fa;
                font-weight: 600;
            }
            
            .cart-summary {
                background-color: #f8f9fa;
                padding: 1.5rem;
                border-radius: 0.25rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }
            
            .checkout-btn {
                width: 100%;
                padding: 0.75rem;
                font-size: 1.1rem;
            }
            
            .btn-remove {
                color: #dc3545;
                background: transparent;
                border: none;
                padding: 0.25rem 0.5rem;
                transition: all 0.2s;
            }
            
            .btn-remove:hover {
                color: #bd2130;
                transform: scale(1.1);
            }
            
            .empty-cart {
                text-align: center;
                padding: 2rem;
            }
            
            .empty-cart i {
                font-size: 4rem;
                color: #ccc;
                margin-bottom: 1rem;
            }
            
            .empty-cart h3 {
                color: #666;
                margin-bottom: 1rem;
            }
            
            .empty-cart .btn {
                padding: 0.5rem 2rem;
            }
            
            .cart-item {
                display: flex;
                align-items: center;
                padding: 1rem 0;
                border-bottom: 1px solid #eee;
            }
            
            .cart-item:last-child {
                border-bottom: none;
            }
            
            .cart-summary-total {
                font-size: 1.25rem;
                font-weight: 600;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 2px solid #dee2e6;
            }
            
            @media (max-width: 768px) {
                .quantity-controls {
                    flex-direction: row;
                }
                
                .quantity-controls .btn {
                    padding: 0.2rem 0.4rem;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="components/navbar.jsp" %>
        <div class="container">
            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="text-center mb-4">Your Shopping Cart</h3>
                            <div class="cart-body">
                                <!-- Cart items will be loaded here by JavaScript -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card cart-summary">
                        <div class="card-body">
                            <h3 class="text-center mb-4">Cart Summary</h3>
                            <div class="cart-summary-body">
                                <!-- Cart summary will be loaded here by JavaScript -->
                            </div>
                            <div class="mt-3">
                                <button class="btn btn-success checkout-btn" onclick="goToCheckout()">
                                    <i class="fa fa-shopping-bag me-2"></i> Proceed to Checkout
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="components/common_modals.jsp" %>

        <script>
            $(document).ready(function() {
                updateCart();
            });
        </script>
    </body>
</html> 