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

            #place-order-btn {
                background-color: #673ab7;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                width: 100%;
                margin-top: 20px;
            }

            #place-order-btn:hover {
                background-color: #563d7c;
            }

            #place-order-btn:disabled {
                background-color: #cccccc;
                cursor: not-allowed;
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
                            <form id="checkoutForm">
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
                                    <input type="tel" class="form-control" id="phone" name="phone" value="<%= user.getUserPhone() %>" required>
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

                                <div class="form-group">
                                    <label for="paymentMethod">Payment Method</label>
                                    <select class="form-control" id="paymentMethod" name="paymentMethod" required>
                                        <option value="">Select Payment Method</option>
                                        <option value="cod">Cash on Delivery</option>
                                        <option value="razorpay">Razorpay</option>
                                    </select>
                                </div>

                                <button type="submit" id="place-order-btn" class="btn btn-primary">
                                    Place Order
                                </button>
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
                                <span>₹<span id="shipping">0.00</span></span>
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
            let totalAmount = 0;

            // Load order summary when page loads
            document.addEventListener('DOMContentLoaded', function() {
                loadOrderSummary();
                validateForm();
                
                // Add form submission handler
                document.getElementById('checkoutForm').addEventListener('submit', function(e) {
                    e.preventDefault(); // Prevent default form submission
                    placeOrder();
                });
            });

            // Add event listeners to all form inputs for validation
            document.querySelectorAll('#checkoutForm input, #checkoutForm select, #checkoutForm textarea').forEach(input => {
                input.addEventListener('input', validateForm);
            });

            function validateForm() {
                const form = document.getElementById('checkoutForm');
                const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
                const placeOrderBtn = document.getElementById('place-order-btn');
                
                let isValid = true;
                inputs.forEach(input => {
                    if (!input.value.trim()) {
                        isValid = false;
                    }
                });

                placeOrderBtn.disabled = !isValid;
            }

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
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h6 class="mb-1">${item.productName}</h6>
                                <small class="text-muted">
                                    Quantity: ${item.productQuantity} × ₹${item.productPrice.toFixed(2)}
                                </small>
                            </div>
                            <span class="text-primary">₹${itemTotal.toFixed(2)}</span>
                        </div>
                    `;
                });

                orderItemsContainer.innerHTML = itemsHtml;

                // Calculate totals
                const shipping = subtotal > 500 ? 0 : 50; // Free shipping for orders above ₹500
                const tax = subtotal * 0.18; // 18% tax
                totalAmount = subtotal + shipping + tax;

                // Update summary values
                document.getElementById('subtotal').textContent = subtotal.toFixed(2);
                document.getElementById('shipping').textContent = shipping.toFixed(2);
                document.getElementById('tax').textContent = tax.toFixed(2);
                document.getElementById('total').textContent = totalAmount.toFixed(2);
            }

            function placeOrder() {
                const form = document.getElementById('checkoutForm');
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return;
                }
                
                // Get cart items from localStorage
                const cart = JSON.parse(localStorage.getItem('cart')) || [];
                
                if (cart.length === 0) {
                    showToast("Your cart is empty!");
                    return;
                }

                const paymentMethod = document.getElementById('paymentMethod').value;
                
                // Create order object
                const orderData = {
                    shippingAddress: {
                        address: document.getElementById('address').value,
                        city: document.getElementById('city').value,
                        state: document.getElementById('state').value,
                        pincode: document.getElementById('pincode').value
                    },
                    paymentMethod: paymentMethod,
                    items: cart.map(item => ({
                        productId: item.productId,
                        productQuantity: item.productQuantity,
                        productPrice: item.productPrice
                    }))
                };

                // Disable the place order button
                const placeOrderBtn = document.getElementById('place-order-btn');
                placeOrderBtn.disabled = true;
                placeOrderBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...';

                if (paymentMethod === 'razorpay') {
                    // First create Razorpay order
                    fetch('RazorpayOrderServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ amount: totalAmount })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            // Initialize Razorpay payment
                            initializeRazorpayPayment(
                                data.orderId,
                                totalAmount,
                                document.getElementById('firstName').value,
                                document.getElementById('email').value,
                                document.getElementById('phone').value
                            );
                            
                            // Store order data in localStorage to be used after payment
                            localStorage.setItem('pendingOrder', JSON.stringify(orderData));
                        } else {
                            throw new Error(data.message || 'Failed to create Razorpay order');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast("Error creating payment: " + error.message);
                        placeOrderBtn.disabled = false;
                        placeOrderBtn.innerHTML = 'Place Order';
                    });
                } else {
                    // For COD, proceed with normal order creation
                    fetch('order', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(orderData)
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            // Clear cart
                            localStorage.removeItem('cart');
                            updateCart();
                            
                            // Show success message and redirect
                            showToast("Order placed successfully!");
                            setTimeout(() => {
                                window.location.href = 'order-confirmation.jsp?orderId=' + data.orderId;
                            }, 1500);
                        } else {
                            throw new Error(data.message || 'Failed to place order');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast("Error placing order: " + error.message);
                        
                        // Re-enable the place order button
                        placeOrderBtn.disabled = false;
                        placeOrderBtn.innerHTML = 'Place Order';
                    });
                }
            }
        </script>
    </body>
</html>
