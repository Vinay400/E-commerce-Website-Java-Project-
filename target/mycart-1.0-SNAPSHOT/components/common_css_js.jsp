<!--css-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="css/style.css">

<!-- Test icon to verify Font Awesome is loading -->
<div id="font-awesome-test" style="display: none;">
    <i class="fas fa-shopping-cart"></i>
</div>

<!--javascript-->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<script src="js/script.js"></script>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    // Razorpay payment initialization
    function initializeRazorpayPayment(orderId, amount, name, email, contact) {
        var options = {
            "key": "rzp_test_On67aDeEYAAIps", // Your test key
            "amount": amount * 100, // Amount in paise
            "currency": "INR",
            "name": "MyCart",
            "description": "Order Payment",
            "image": "https://example.com/your_logo.png",
            "order_id": orderId,
            "handler": function (response) {
                // Get the pending order from localStorage
                const orderData = JSON.parse(localStorage.getItem('pendingOrder'));
                if (!orderData) {
                    showToast("Error: Order data not found");
                    return;
                }

                // Add payment details to order data
                orderData.razorpayPaymentId = response.razorpay_payment_id;
                orderData.razorpayOrderId = response.razorpay_order_id;
                orderData.razorpaySignature = response.razorpay_signature;

                // Create the order in our system
                fetch('order', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(orderData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Clear cart and pending order
                        localStorage.removeItem('cart');
                        localStorage.removeItem('pendingOrder');
                        updateCart();
                        
                        // Show success message and redirect
                        showToast("Payment successful! Order placed.");
                        setTimeout(() => {
                            window.location.href = "order-confirmation.jsp?orderId=" + data.orderId;
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Failed to create order');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast("Error creating order: " + error.message);
                });
            },
            "prefill": {
                "name": name,
                "email": email,
                "contact": contact
            },
            "theme": {
                "color": "#673ab7"
            },
            "modal": {
                "ondismiss": function() {
                    // Re-enable place order button if payment modal is dismissed
                    const placeOrderBtn = document.getElementById('place-order-btn');
                    if (placeOrderBtn) {
                        placeOrderBtn.disabled = false;
                        placeOrderBtn.innerHTML = 'Place Order';
                    }
                }
            }
        };
        var rzp1 = new Razorpay(options);
        rzp1.open();
    }
</script>

<style>
    .custom-bg {
        background: #673ab7!important;
    }
    
    .admin .card {
        border: 1px solid #673ab7;
    }
    
    .card-columns {
        column-count: 3;
    }
    
    .product-card:hover {
        background: #e2e2e2;
        cursor: pointer;
    }
    
    .list-group-item.active {
        background: #673ab7!important;
        border-color: #673ab7!important;
    }
    
    .discount-label {
        font-size: 10px!important;
        font-style: italic!important;
        text-decoration: line-through!important;
    }
    
    .price-style {
        font-size: 20px;
        font-weight: bold;
    }

    #toast {
        min-width: 300px;
        position: fixed;
        bottom: 30px;
        left: 50%;
        margin-left: -120px;
        background: #333;
        padding: 15px;
        color: white;
        text-align: center;
        z-index: 1;
        font-size: 18px;
        visibility: hidden;
        box-shadow: 0px 0px 100px #000;
    }

    #toast.display {
        visibility: visible;
        animation: fadeIn 0.5s, fadeOut 0.5s 2.5s;
    }

    @keyframes fadeIn {
        from {
            bottom: 0;
            opacity: 0;
        }
        to {
            bottom: 30px;
            opacity: 1;
        }
    }

    @keyframes fadeOut {
        from {
            bottom: 30px;
            opacity: 1;
        }
        to {
            bottom: 0;
            opacity: 0;
        }
    }
</style>