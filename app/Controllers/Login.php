<?php

namespace App\Controllers;

use App\Models\UserModel;
use CodeIgniter\Controller;
use Config\Database;

class Login extends Controller
{
    public function index(): string
    {
        return view('Login');
    }

    public function Profil(): string
    {
        return view('Profil');
    }

    public function Create(): string
    {
        return view('Create');
    }



    public function account()
    {
       
        // Validation
        // $validation = \Config\Services::validation();
        // $validation->setRules([
        //     'email' => 'required|valid_email|is_unique[Adherents.mail]',
        //     'password' => 'required|min_length[6]',
        // ]);
    
        // if (!$this->validate($validation->getRules())) {
        //     return redirect()->to('/Create')->with('errors', $validation->getErrors());
        // }
        $pswd = $this->request->getPost('pass');
        // Hashage en PHP
        //$pswd = password_hash($pswd, PASSWORD_BCRYPT);
   
        // Preparation des données
        $data = [
            'mail' => $this->request->getPost('mail'),
            'password' => $pswd,
            'nom' => $this->request->getPost('nom'),
            'prenom' => $this->request->getPost('prenom'),
            'age' => $this->request->getPost('age'),
            'adresse' => $this->request->getPost('adresse'),



        ];
    
        // Enregistrement et redirection
        $userModel = new \App\Models\UserModel();
        if ($userModel->save($data)) {
            return redirect()->to('/Login')->with('success', 'User registered successfully.');
        } else {
        }
    }


    public function authenticate()
    {
        
        

        $mail = $this->request->getPost('login');
        $password = $this->request->getPost('pass');

        // Verification des parametres
       
        $userModel = new UserModel();
        $user = $userModel->findByEmail($mail);

        // Get the database connection
        $db = \Config\Database::connect();

        $sql = "SELECT dbo.VerifLoginPassword(:mail:, :password:) AS estValide";
        
        // Execute the query
        $query = $db->query($sql, [
            'mail' => $mail,
            'password' => $password,
        ]);
        // Fetch the result
        $result = $query->getRow();

        if ($result->estValide) {
            session()->set([
                'user_id' => $user['idAdherents'],
                'mail' => $user['mail'],
                'is_logged_in' => true,
            ]);
       

        
            return redirect()->to('/Profil')->with('success', 'Logged in successfully.');
        }


        return redirect()->back()->withInput()->with('errors', ['Invalid mail or password.']);
    }


    public function Logout()
    {
        // Deconnexion
        session()->destroy();

        return redirect()->to('/Login')->with('success', 'Logged out successfully.');
    }
}
