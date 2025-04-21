// Check if product is in cart
function isProductInCart(pid) {
    let cart = localStorage.getItem("cart");
    if (cart != null) {
        let pcart = JSON.parse(cart);
        return pcart.some(item => item.productId == pid);
    }
    return false;
}

// Update all add to cart buttons
function updateAddToCartButtons() {
    // Find all add to cart buttons
    $('.add-to-cart-btn').each(function() {
        const pid = $(this).data('pid');
        if (isProductInCart(pid)) {
            $(this).html('<i class="fa fa-check"></i> Added');
            $(this).removeClass('btn-primary').addClass('btn-success');
        } else {
            $(this).html('<i class="fa fa-shopping-cart"></i> Add to Cart');
            $(this).removeClass('btn-success').addClass('btn-primary');
        }
    });
}

function add_to_cart(pid, pname, price, quantity = 1) {
    // Validate inputs
    if (!pid || !pname || price === undefined || price === null) {
        console.error('Invalid product data:', { pid, pname, price });
        showToast("Error: Invalid product data");
        return;
    }

    // Convert price to number and validate
    const numericPrice = parseFloat(price);
    if (isNaN(numericPrice)) {
        console.error('Invalid price value:', price);
        showToast("Error: Invalid price value");
        return;
    }

    let cart = localStorage.getItem("cart");
    if (cart == null) {
        // no cart yet
        let products = [];
        let product = {
            productId: pid,
            productName: pname,
            productQuantity: quantity,
            productPrice: numericPrice
        };
        products.push(product);
        localStorage.setItem("cart", JSON.stringify(products));
        showToast("Item is added to cart");
    } else {
        // cart is already present
        let pcart = JSON.parse(cart);
        let oldProduct = pcart.find((item) => item.productId === pid);
        
        if (oldProduct) {
            // product already exists, update quantity
            oldProduct.productQuantity = parseInt(oldProduct.productQuantity) + quantity;
            pcart = pcart.map((item) => 
                item.productId === oldProduct.productId ? oldProduct : item
            );
            localStorage.setItem("cart", JSON.stringify(pcart));
            showToast("Product quantity updated in cart");
        } else {
            // product not present
            let product = {
                productId: pid,
                productName: pname,
                productQuantity: quantity,
                productPrice: numericPrice
            };
            pcart.push(product);
            localStorage.setItem("cart", JSON.stringify(pcart));
            showToast("Product is added to cart");
        }
    }
    updateCart();
    updateAddToCartButtons();
}

//update cart:
function updateCart() {
    let cartString = localStorage.getItem("cart");
    let cart = [];
    
    try {
        cart = JSON.parse(cartString) || [];
    } catch (e) {
        console.error('Error parsing cart data:', e);
        localStorage.setItem("cart", "[]");
    }

    if (!cart || cart.length == 0) {
        console.log("Cart is empty !!");
        $(".cart-items").html("( 0 )");
        $(".cart-body").html(`
            <div class="empty-cart">
                <i class="fa fa-shopping-cart"></i>
                <h3>Your cart is empty</h3>
                <p>Add items to your cart to see them here</p>
                <a href="index.jsp" class="btn btn-primary">Start Shopping</a>
            </div>
        `);
        $(".cart-summary-body").html(`
            <div class="text-center">
                <p>No items in cart</p>
                <hr>
                <h4>Total: ₹0.00</h4>
            </div>
        `);
        $(".checkout-btn").attr('disabled', true);
        return;
    }

    //there is something in cart to show
    console.log(cart);
    $(".cart-items").html(`( ${cart.length} )`);
    
    let table = `
        <table class='table'>
            <thead class='thead-light'>
                <tr>
                    <th>Item Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    let totalPrice = 0;
    cart.forEach((item) => {
        // Ensure numeric values
        const quantity = parseInt(item.productQuantity) || 0;
        const price = parseFloat(item.productPrice) || 0;
        const itemTotal = quantity * price;
        totalPrice += itemTotal;
        
        table += `
            <tr>
                <td>${item.productName || 'Unknown Product'}</td>
                <td>₹${price.toFixed(2)}</td>
                <td> 
                    <div class="quantity-controls">
                        <button onclick='decreaseQuantity(${item.productId})' class='btn btn-sm btn-light'><i class="fa fa-minus"></i></button>
                        <span class="mx-2">${quantity}</span>
                        <button onclick='increaseQuantity(${item.productId})' class='btn btn-sm btn-light'><i class="fa fa-plus"></i></button>
                    </div>
                </td>
                <td>₹${itemTotal.toFixed(2)}</td>
                <td>
                    <button onclick='deleteItemFromCart(${item.productId})' class='btn-remove'>
                        <i class="fa fa-trash"></i>
                    </button>
                </td>    
            </tr>
        `;
    });

    table += `
            </tbody>
        </table>
    `;
    
    $(".cart-body").html(table);
    
    // Calculate additional charges
    const shipping = totalPrice > 500 ? 0 : 50;
    const tax = totalPrice * 0.18;
    const finalTotal = totalPrice + shipping + tax;
    
    // Update cart summary
    $(".cart-summary-body").html(`
        <div>
            <div class="d-flex justify-content-between mb-2">
                <span>Subtotal:</span>
                <span>₹${totalPrice.toFixed(2)}</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Shipping:</span>
                <span>₹${shipping.toFixed(2)}</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Tax (18%):</span>
                <span>₹${tax.toFixed(2)}</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between cart-summary-total">
                <strong>Total:</strong>
                <strong>₹${finalTotal.toFixed(2)}</strong>
            </div>
        </div>
    `);
    
    $(".checkout-btn").attr('disabled', false);
}

//delete item 
function deleteItemFromCart(pid)
{
    let cart = JSON.parse(localStorage.getItem('cart'));
    let newcart = cart.filter((item) => item.productId != pid)
    localStorage.setItem('cart', JSON.stringify(newcart))
    updateCart();
    showToast("Item is removed from cart ")
}

// Increase quantity of an item in cart
function increaseQuantity(pid) {
    let cart = JSON.parse(localStorage.getItem('cart'));
    let item = cart.find(item => item.productId === pid);
    if (item) {
        item.productQuantity += 1;
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCart();
        showToast("Quantity increased");
    }
}

// Decrease quantity of an item in cart
function decreaseQuantity(pid) {
    let cart = JSON.parse(localStorage.getItem('cart'));
    let item = cart.find(item => item.productId === pid);
    if (item) {
        if (item.productQuantity > 1) {
            item.productQuantity -= 1;
            localStorage.setItem('cart', JSON.stringify(cart));
            updateCart();
            showToast("Quantity decreased");
        } else {
            deleteItemFromCart(pid);
        }
    }
}

$(document).ready(function () {
    updateCart()
    updateAddToCartButtons()
})

function showToast(content) {
    $("#toast").addClass("display");
    $("#toast").html(content);
    setTimeout(() => {
        $("#toast").removeClass("display");
    }, 2000);
}

function goToCheckout() {
    window.location = "checkout.jsp"
}

// Function to show quantity controls and hide Add to Cart button
function showQuantityControls(productId) {
    // Hide the initial add to cart button
    document.getElementById(`add-to-cart-${productId}`).style.display = 'none';
    // Show the quantity controls
    document.getElementById(`quantity-controls-${productId}`).classList.remove('d-none');
}

function incrementQuantity(productId, maxQuantity) {
    const input = document.getElementById(`quantity-${productId}`);
    const currentValue = parseInt(input.value);
    if (currentValue < maxQuantity) {
        input.value = currentValue + 1;
    }
}

function decrementQuantity(productId) {
    const input = document.getElementById(`quantity-${productId}`);
    const currentValue = parseInt(input.value);
    if (currentValue > 1) {
        input.value = currentValue - 1;
    }
}

function validateQuantity(productId, maxQuantity) {
    const input = document.getElementById(`quantity-${productId}`);
    let value = parseInt(input.value);
    
    if (isNaN(value) || value < 1) {
        value = 1;
    } else if (value > maxQuantity) {
        value = maxQuantity;
    }
    
    input.value = value;
}

function confirmAddToCart(productId, name, price) {
    const quantity = parseInt(document.getElementById(`quantity-${productId}`).value);
    add_to_cart(productId, name, price, quantity);
    
    // Reset and hide quantity controls
    document.getElementById(`quantity-${productId}`).value = 1;
    document.getElementById(`quantity-controls-${productId}`).classList.add('d-none');
    document.getElementById(`add-to-cart-${productId}`).style.display = 'block';
}