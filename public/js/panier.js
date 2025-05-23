const produits = document.querySelectorAll("#liste_produits li");
const panierElement = document.querySelector(".panier");
const PRIX_PAR_PRODUIT = 70;

produits.forEach((produit) => {
  produit.addEventListener("click", () => {
    const fruit = produit.textContent.trim();
    if (produitExisteDeja(fruit)) {
      const li = document.querySelector(`#${CSS.escape(fruit)}`);
      const count = parseInt(li.getAttribute("count")) + 1;
      li.setAttribute("count", count);
    } else {
      ajouterProduitAuPanier(fruit);
    }
    mettreAJourAffichagePanier();
  });
});

function produitExisteDeja(nom) {
  const items = document.querySelectorAll(".panier li");
  return [...items].some((li) => li.id === nom);
}

function ajouterProduitAuPanier(nom) {
  const li = document.createElement("li");
  li.className = "list-group-item d-flex justify-content-between align-items-center";
  li.id = nom;
  li.setAttribute("count", 1);
  li.setAttribute("price", PRIX_PAR_PRODUIT);

  const span = document.createElement("span");
  span.className = "span_price";
  li.appendChild(span);

  const boutonRetirer = document.createElement("button");
  boutonRetirer.className = "btn btn-danger btn-sm";
  boutonRetirer.textContent = "Retirer";
  boutonRetirer.addEventListener("click", () => retirerProduit(nom));
  li.appendChild(boutonRetirer);

  panierElement.appendChild(li);
}

function retirerProduit(nom) {
  const li = document.querySelector(`#${CSS.escape(nom)}`);
  let count = parseInt(li.getAttribute("count"));
  if (count > 1) {
    count--;
    li.setAttribute("count", count);
  } else {
    li.remove();
  }
  mettreAJourAffichagePanier();
}

function mettreAJourAffichagePanier() {
  const items = document.querySelectorAll(".panier li");
  let total = 0;

  items.forEach((item) => {
    const nom = item.id;
    const count = parseInt(item.getAttribute("count"));
    const prix = parseFloat(item.getAttribute("price"));
    total += count * prix;

    const span = item.querySelector(".span_price");
    span.textContent = `${nom} ${count} x ${prix} = ${count * prix}€`;
  });

  const totalDiv = document.querySelector("#total");
  if (totalDiv) totalDiv.textContent = `Total : ${total}€`;
}