<?php

namespace  App\Models;

use  CodeIgniter\Model;

class UserModel extends Model {
    protected $useAutoIncrement = true;
    protected $useTimestamps = false;
    protected $skipValidation = true;
    protected $returnType = 'array';
    protected $useSoftDeletes = false;

    protected $table = 'Adherents';
    protected $primaryKey = 'idAdherents';
    protected $allowedFields = ['mail', 'nom', 'prenom', 'password', 'age', 'adresse'];
    
    public function findByEmail($mail)
    {
        return $this->where('mail', $mail)->first();
    }
    
}