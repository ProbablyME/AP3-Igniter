<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="/css/stylesCreate.css">


<title>Bootstrap Simple Login Form</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>

</head>
<body>
<div class="login-form">
    <form action="<?php echo(base_url('Login/Account')) ?>" method="POST">
        <h2 class="text-center">Register</h2>
        <div class="form-group">
            <input type="name" class="form-control" placeholder="Nom" required="required" name="nom">
        </div>
        <div class="form-group">
            <input type="text" class="form-control" placeholder="Prenom" required="required" name="prenom">
        </div>
        <div class="form-group">
            <input type="email" class="form-control" placeholder="Mail" required="required" name="mail">
        </div>

        <div class="form-group">
            <input type="password" class="form-control" placeholder="Password" required="required" name="pass">
        </div>

        <div class="form-group">
            <input type="text" class="form-control" placeholder="Adresse" required="required" name="adresse">
        </div>
        <div class="form-group">
            <input type="int" class="form-control" placeholder="Age" required="required" name="age">
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-primary btn-block">Register Account</button>
        </div>

    </form>
</div>
</body>
</html>
