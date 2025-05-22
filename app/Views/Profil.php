<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/stylesProfil.css"> 

    <title>Welcome</title>
</head>
<body>





<?php
// Récupérer l'email de l'utilisateur connecté
$email = session()->get('mail');
echo "<h1>" . $email . "</h1>";

$db = \Config\Database::connect();

try {
    // Récupérer l'idAdherents de l'utilisateur à partir de son email
    $builder = $db->table('Adherents');
    $builder->select('idAdherents');
    $builder->where('mail', $email);
    $adherent = $builder->get()->getRow();

    if ($adherent) {
        $idAdherent = $adherent->idAdherents;

        // Vérifier si l'utilisateur est un dirigeant
        $builder = $db->table('Dirigeant');
        $builder->where('idAdherents', $idAdherent);
        $dirigeant = $builder->get()->getRow();

        // Vérifier si l'utilisateur est un joueur
        $builder = $db->table('Joueur');
        $builder->where('idAdherents', $idAdherent);
        $joueur = $builder->get()->getRow();

        if ($dirigeant) {

            ?>
                <h1>Page Dirigeant</h1>
            <?php

            // Si l'utilisateur est un dirigeant, afficher le tableau
            $sql = "EXEC dbo.HeuresEntrainementParJoueur";
            $query = $db->query($sql);
            $results = $query->getResult();
            
            echo "<table border='1'>";
            echo "<tr><th>Nom du Joueur</th><th>Heures d'entraînement</th></tr>";
            foreach ($results as $row) {
                echo "<tr>";
                echo "<td>" . $row->nom. "</td>";
                echo "<td>" . $row->totalMinutes . "</td>";
                echo "</tr>";
            }
            echo "</table>";
?>
            <a class='deconnecter' href=<?php echo(base_url('Crud')) ?>>Crud</a>
<?php
        }
        elseif ($joueur) {

            ?>
                <h1>Page Joueur</h1>
            <?php
            
            $builder = $db->table('Adherents');
            $builder->select('*');
            $builder->join('Appel','Adherents.idAdherents = Appel.idAdherents');
            $builder->join('Evenements','Appel.idEvenement = Evenements.idEvenement');
            $Evenement = $builder->get();

            echo "<table border='1'>";
            echo "<tr><th>Nom du Joueur</th><th>Nom Evenement</th></tr>";
            foreach ($Evenement->getResult() as $row) {
                echo "<tr>";
                echo "<td>" . $row->nom. "</td>";
                echo "<td>" . $row->nomEvenement . "</td>";
                echo "</tr>";
            }
            echo "</table>";

      
        }
        else{
            ?>
                <h1>Page Invité</h1>
            <?php
        }
    }
} catch (\Exception $e) {
    // Gestion des erreurs
    echo "Erreur : " . $e->getMessage();
}
?>







<br><br><br><br>

<a class='deconnecter' href=<?php echo(base_url('Acceuil')) ?>>Acceuil</a>
<br><br>

<a class='deconnecter' href=<?php echo(base_url('Logout')) ?>>Se déconnecter</a>



</body>
</html>
