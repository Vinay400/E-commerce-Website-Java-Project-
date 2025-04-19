<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart Page</title>
        <%@include file="components/common_css_js.jsp" %>
    </head>
    <body>
        <%@include  file="components/navbar.jsp" %>
        <div class="container">
            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-body cart-body">

                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="text-center mb-4">Your Cart Summary</h3>
                            <div class="cart-body">
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button class="btn btn-success checkout-btn" onclick="goToCheckout()">Checkout</button>
                    </div>
                </div>
            </div>
        </div>
        <%@include  file="components/common_modals.jsp" %>
    </body>
</html> 