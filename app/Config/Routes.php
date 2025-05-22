<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Accueil::index');
$routes->get('Acceuil', 'Accueil::index');
$routes->get('/Login', 'Login::index');
$routes->get('/Profil', 'Login::Profil');
$routes->post('/Login/Authenticate', 'Login::authenticate');
$routes->get('/Logout','Login::Logout');
$routes->get('/Create','Login::Create');
$routes->post('Login/Account' , 'Login::account');
$routes->get('Crud' , 'Crud::index');

$routes->get('/crud/edit/(:num)', 'Crud::edit/$1');
$routes->get('/crud/delete/(:num)', 'Crud::delete/$1');
$routes->post('/crud/update', 'Crud::update');



