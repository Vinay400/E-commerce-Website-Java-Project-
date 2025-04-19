<!--css-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/style.css">

<!--javascript-->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<script src="js/script.js"></script>

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