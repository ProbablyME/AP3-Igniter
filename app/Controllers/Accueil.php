<?php

namespace App\Controllers;

class Accueil extends BaseController
{
    public function index(): string
    {
        return view('Accueil');
    }
}
