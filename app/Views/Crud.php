<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Adherents</title>
    

<link href="/css/styleCrud.css" rel="stylesheet">

</head>
<body>

<?php
$db = \Config\Database::connect();

try {
    // Récupérer tous les adhérents depuis la table "Adherents"
    $builder = $db->table('Adherents');
    $adherents = $builder->get()->getResult(); // Renvoie un tableau d'objets
} catch (\Exception $e) {
    echo "Erreur : " . htmlspecialchars($e->getMessage());
    exit;
}
?>

<h1>Liste des Adherents</h1>

<?php if (!empty($adherents)): ?>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($adherents as $adherent): ?>
                <tr>
                    <td><?= $adherent->idAdherents ?></td>
                    <td><?= $adherent->nom ?></td>
                    <td><?= $adherent->prenom ?></td>
                    <td><?= $adherent->mail ?></td>
                    <td>
                    <a href="<?= base_url('crud/edit/' . $adherent->idAdherents) ?>" class="btn-modifier">Modifier</a> |
                    <a href="<?= base_url('crud/delete/' . $adherent->idAdherents) ?>" class="btn-supprimer" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet adhérent ?');">Supprimer</a>

                    <?php if (isset($editMode) && $editMode): ?>
                        <h2>Modifier Adhérent</h2>
                        <form action="<?= base_url('/crud/update') ?>" method="post">
                            <!-- Champ caché pour l'ID -->
                            <input type="hidden" name="id" value="<?= $user['idAdherents'] ?>">

                            <label for="nom">Nom :</label>
                            <input type="text" id="nom" name="nom" value="<?= $user['nom'] ?>" required><br>

                            <label for="prenom">Prénom :</label>
                            <input type="text" id="prenom" name="prenom" value="<?= $user['prenom'] ?>" required><br>

                            <label for="mail">Email :</label>
                            <input type="email" id="mail" name="mail" value="<?= $user['mail'] ?>" required><br>

                            <label for="password">Mot de passe :</label>
                            <input type="password" id="password" name="password" value="<?= $user['password'] ?>" required><br>

                            <label for="age">Âge :</label>
                            <input type="number" id="age" name="age" value="<?= $user['age'] ?>" required><br>

                            <label for="adresse">Adresse :</label>
                            <input type="text" id="adresse" name="adresse" value="<?= $user['adresse'] ?>" required><br>

                            <button type="submit">Modifier</button>
                        </form>
                    <?php endif; ?>


                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php else: ?>
    <p>Aucun adhérent trouvé dans la base de données.</p>
<?php endif; ?>

</body>
</html>
