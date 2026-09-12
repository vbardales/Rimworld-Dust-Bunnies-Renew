---
mod:        Dust Bunnies Renew
packageId:  nelim.dustbunniesrenew
depot:      Rimworld-Dust-Bunnies-Renew
visibilite: public
detache:    oui
etape:      done
licence:    silent
licence_ou: quatre endroits ; le dépôt lié rend license: null
vitrine:    complete
teste_le:
workshop:
reste:
  - non_verifie: la recette qui fait naître l'animal, seul endroit où le C# du mod s'exécute
  - non_verifie: l'entraînement, la bête restant au stade AnimalBaby à vie
  - non_verifie: les seize autres scénarios de _tools/FUNCTIONAL-SCENARIOS.md
session:    local_49e74fa8-1876-4ba3-92c3-10edeb90216f
maj:        2026-09-12, session du mod
---

# Dust Bunnies Renew — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

Les champs deduits du disque le 2026-09-12 ont ete verifies un a un et sont justes. Les trois
que le releve ne pouvait pas remplir sont tranches ici.

- **`etape`** — `done` confirme, au sens ou le travail est fini et non au sens ou il est publie :
  les deux corrections du portage, le C# reecrit, le francais, la vitrine et les scenarios sont
  en place, et le depot n'a plus rien en attente. Vingt et un des vingt-deux mods marques `done`
  du depot sont dans le meme etat, sans item Workshop.
- **`teste_le`** — vide, et la ligne posee d'office par le releve dit vrai : **ce mod n'a jamais
  ete charge par RimWorld**, ni dans sa forme d'origine depuis 2021 ni dans ce portage.
- **`reste`** — les trois lignes sont du non verifie, pas du casse. Aucun defaut connu non
  corrige ; ce qui ressemble a des oublis dans les defs — `mateMtbHours` 0 a cote d'une
  `litterSizeCurve`, un `ecoSystemWeight` sur un animal qui n'appartient a aucun biome, un
  cadavre desseche dessine comme un vivant — a ete constate, documente et laisse tel quel,
  parce que c'est leur equilibrage et non celui du portage.

**Pourquoi la premiere ligne de `reste` passe devant les autres.** Tout le mod est une methode de
`RecipeWorker`, et **rien ne l'appelle avant qu'un colon termine la bill** : ni le chargement, ni
la mise en file, ni le debut du travail. Un `workerClass` qui ne se resout pas laisse le champ a
null sans tuer la def, donc la recette consommerait les cent poussieres, ferait ses 800 ticks,
finirait le travail et ne produirait rien — et tout le reste du mod continuerait de bien se tenir.
Chaque appel au jeu a ete verifie par reflexion contre la 1.6 avant d'ecrire une ligne, ce qui
rend la panne improbable, mais la reflexion prouve qu'une methode existe encore avec cette forme,
pas que le jeu fait encore la chose.

Pas de jeu de tests hors jeu a cote, et c'est delibere : il n'y a rien a executer sans carte,
colon et bill.

`_tools/FUNCTIONAL-SCENARIOS.md` reste la source : dix-huit scenarios, un seul point a observer
chacun, la ligne de `Player.log` qui dit de quelle panne il s'agit, et ce qu'ils ne couvrent pas.
Cette fiche n'en garde que le solde.

**Dernier releve de chiffres, le 2026-09-12.** Ecrire ces scenarios a trouve trois affirmations
fausses dans la documentation du portage — poussiere dite chaude alors qu'elle est le pire isolant
du jeu, dite tres inflammable alors que son facteur est sous celui du tissu, et une decoupe
annoncee a 50 poussieres pour un rendement reel d'environ 18. Corrigees dans l'`About.xml`, le
README et le CHANGELOG. La description Workshop ne partant qu'a la creation de l'item, la fenetre
pour ce genre de correction se ferme a la publication.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.
