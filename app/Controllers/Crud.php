<?php

namespace App\Controllers;

use App\Models\UserModel;

class Crud extends BaseController
{

    public function index(): string
    {
        return view('Crud');
    }

    // public function index(): string
    // {
    //     $model = new UserModel();
    //     $data['adherents'] = $model->findAll();

    //     return view('Crud', $data);
    // }

    public function delete($id)
    {
        $model = new UserModel();

        if ($model->delete($id)) {
            return redirect()->to('/Crud')->with('success', 'User deleted successfully.');
        } else {
            return redirect()->to('/Crud')->with('error', 'Failed to delete user.');
        }
    }

    public function edit($id): string
    {
        $model = new UserModel();
    $data['user'] = $model->find($id);

    if (!$data['user']) {
        return redirect()->to('/Crud')->with('error', 'Adhérent non trouvé.');
    }

    $data['adherents'] = $model->findAll(); // Charger tous les adhérents pour la vue principale
    $data['editMode'] = true; // Indiquer que l'édition est en cours
    return view('Crud', $data); // Utiliser la vue existante
    }

    public function update()
    {
        $model = new UserModel();

        $id = $this->request->getPost('id');
        $data = [
            'mail' => $this->request->getPost('mail'),
            'nom' => $this->request->getPost('nom'),
            'prenom' => $this->request->getPost('prenom'),
            'password' => $this->request->getPost('password'),
            'age' => $this->request->getPost('age'),
            'adresse' => $this->request->getPost('adresse'),
        ];

        if ($model->update($id, $data)) {
            return redirect()->to('/Crud')->with('success', 'User updated successfully.');
        } else {
            return redirect()->to('/Crud')->with('error', 'Failed to update user.');
        }
    }
}
