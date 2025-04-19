<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
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
        <title>Checkout - MyCart</title>
        <%@include file="components/common_css_js.jsp"%>
        <style>
            .form-control:focus {
                border-color: #673ab7;
                box-shadow: 0 0 0 0.2rem rgba(103, 58, 183, 0.25);
            }
            
            .order-summary {
                background-color: #f8f9fa;
                border-radius: 0.5rem;
                padding: 1.5rem;
            }
            
            .divider {
                border-top: 1px solid #dee2e6;
                margin: 1rem 0;
            }
        </style>
    </head>
    <body>
        <%@include file="components/navbar.jsp"%>
        
        <div class="container mt-4">
            <div class="row">
                <!-- Shipping Details Form -->
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Shipping Details</h4>
                        </div>
                        <div class="card-body">
                            <form id="checkoutForm" onsubmit="return placeOrder(event)">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="firstName" class="form-label">First Name</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" value="<%= user.getUserName() %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="lastName" class="form-label">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= user.getUserEmail() %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                </div>

                                <div class="mb-3">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="city" class="form-label">City</label>
                                        <input type="text" class="form-control" id="city" name="city" required>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="state" class="form-label">State</label>
                                        <input type="text" class="form-control" id="state" name="state" required>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="pincode" class="form-label">PIN Code</label>
                                        <input type="text" class="form-control" id="pincode" name="pincode" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="paymentMethod" class="form-label">Payment Method</label>
                                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                        <option value="">Choose...</option>
                                        <option value="cod">Cash on Delivery</option>
                                        <option value="card">Credit/Debit Card</option>
                                        <option value="upi">UPI</option>
                                    </select>
                                </div>

                                <div id="cardDetails" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="cardNumber" class="form-label">Card Number</label>
                                            <input type="text" class="form-control" id="cardNumber" name="cardNumber">
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <label for="expiryDate" class="form-label">Expiry Date</label>
                                            <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY">
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <label for="cvv" class="form-label">CVV</label>
                                            <input type="password" class="form-control" id="cvv" name="cvv" maxlength="3">
                                        </div>
                                    </div>
                                </div>

                                <div id="upiDetails" style="display: none;">
                                    <div class="mb-3">
                                        <label for="upiId" class="form-label">UPI ID</label>
                                        <input type="text" class="form-control" id="upiId" name="upiId" placeholder="username@upi">
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mt-3">Place Order</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Order Summary</h4>
                        </div>
                        <div class="card-body">
                            <div id="orderItems">
                                <!-- Order items will be loaded here -->
                            </div>
                            <div class="divider"></div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>₹<span id="subtotal">0.00</span></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span>₹<span id="shipping">50.00</span></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tax (18%):</span>
                                <span>₹<span id="tax">0.00</span></span>
                            </div>
                            <div class="divider"></div>
                            <div class="d-flex justify-content-between">
                                <strong>Total:</strong>
                                <strong>₹<span id="total">0.00</span></strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Load order summary when page loads
            document.addEventListener('DOMContentLoaded', function() {
                loadOrderSummary();
                setupPaymentMethodListener();
            });

            function loadOrderSummary() {
                const cart = JSON.parse(localStorage.getItem('cart')) || [];
                const orderItemsContainer = document.getElementById('orderItems');
                
                if (cart.length === 0) {
                    window.location.href = 'cart.jsp';
                    return;
                }

                let itemsHtml = '';
                let subtotal = 0;

                cart.forEach(item => {
                    const itemTotal = item.productPrice * item.productQuantity;
                    subtotal += itemTotal;
                    
                    itemsHtml += `
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <h6 class="mb-0">${item.productName}</h6>
                                <small class="text-muted">Qty: ${item.productQuantity} × ₹${item.productPrice}</small>
                            </div>
                            <span>₹${itemTotal}</span>
                        </div>
                    `;
                });

                orderItemsContainer.innerHTML = itemsHtml;

                // Calculate totals
                const shipping = subtotal > 500 ? 0 : 50;
                const tax = subtotal * 0.18;
                const total = subtotal + shipping + tax;

                document.getElementById('subtotal').textContent = subtotal.toFixed(2);
                document.getElementById('shipping').textContent = shipping.toFixed(2);
                document.getElementById('tax').textContent = tax.toFixed(2);
                document.getElementById('total').textContent = total.toFixed(2);
            }

            function setupPaymentMethodListener() {
                const paymentMethod = document.getElementById('paymentMethod');
                const cardDetails = document.getElementById('cardDetails');
                const upiDetails = document.getElementById('upiDetails');

                paymentMethod.addEventListener('change', function() {
                    cardDetails.style.display = this.value === 'card' ? 'block' : 'none';
                    upiDetails.style.display = this.value === 'upi' ? 'block' : 'none';

                    // Reset validation requirements based on payment method
                    const cardInputs = cardDetails.querySelectorAll('input');
                    const upiInput = upiDetails.querySelector('input');

                    cardInputs.forEach(input => {
                        input.required = this.value === 'card';
                    });
                    if (upiInput) {
                        upiInput.required = this.value === 'upi';
                    }
                });
            }

            function placeOrder(event) {
                event.preventDefault();
                
                const form = event.target;
                const formData = new FormData(form);
                const cart = JSON.parse(localStorage.getItem('cart')) || [];
                
                if (cart.length === 0) {
                    showToast("Your cart is empty!");
                    return false;
                }

                // Create order object
                const shippingAddress = {
                    firstName: formData.get('firstName'),
                    lastName: formData.get('lastName'),
                    email: formData.get('email'),
                    phone: formData.get('phone'),
                    address: formData.get('address'),
                    city: formData.get('city'),
                    state: formData.get('state'),
                    pincode: formData.get('pincode')
                };

                const order = {
                    items: cart,
                    shippingAddress: shippingAddress,
                    paymentMethod: formData.get('paymentMethod'),
                    userId: '<%= user.getUserId() %>'
                };

                // Save order details for confirmation page
                localStorage.setItem('lastOrder', JSON.stringify({
                    shippingAddress: shippingAddress,
                    orderId: 'ORD' + Date.now()
                }));

                // Send order to server
                fetch('OrderServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(order)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Clear cart and redirect to confirmation page
                        localStorage.removeItem('cart');
                        window.location.href = 'order-confirmation.jsp?orderId=' + data.orderId;
                    } else {
                        showToast(data.message || 'Error placing order');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Error placing order. Please try again.');
                });

                return false;
            }
        </script>
    </body>
</html>
