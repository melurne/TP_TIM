# Codage et Transmission en bande de base

Ce TP vise à découvrir et comprendre les différentes méthodes de codage de source et à leur transmission en bande passante. Tout ceci sera effectué à l'aide du logiciel Scilab.

## Partie 1 : Génération d'une séquence pseudo-aléatoire et codage en ligne

On génère un vecteur rempli aléatoirement de 0 et de 1 qui ferra office de message à transmettre. 

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/fct%20message.PNG)

![graph vecteur pas bo](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/Message%20binaire.PNG)

Pour que la modulation soit plus propre, on a besoin de convertir ce vecteur en une représentation d'un signal carré (étendre chaque bit sur une période).

![Message codé](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/info%20cod%C2%82e.PNG)

---

### Codage NRZ bipolaire

On fait correspondre 

> Un bit à 0 -> -5V
> 
> Un bit à 1 -> +5V

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/nrz%20bip.PNG)

![NRZ](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/info%20cod%C2%82e%20bip.PNG)

### Codage Manchester

On implémente un codage Manchester pour la transmission du signal, ce codage transforme un bit du signal en une période du nouveau signal et en faisant correspondre

> Un bit à 0 -> un front montant
> 
> Un bit à 1 -> un front descendant

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/fct%20manchester.PNG)

![Manchester](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/mach%20%2B%20bip.PNG)

---

### FFT

L'utilisation du codage Manchester amène un premier zéro 2 foix plus éloigné qu'en bande de base de par la substitution d'un bit en bande de base par une période de signal au lieu d'une demi en bande de base. Le lobe du codage Manchester est donc deux fois plus grand que celui en bande de base.

 ![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/dsp%20100.PNG)

## Partie 2 : Adjonction d'un bruit gaussien, représentation temporelle et prise de décision

### Filtrage

Pour simuler l'action d'un canal de transmission, on va filtrer le signal afin de ne transmettre que le premier lobe de la FFT. Pour cela on annule le signal à partir du premier echantillon au dessous de 0.

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/filtrage%20nrz.PNG)

### Inclusion de bruit

Pour simuler l'effet d'un canal de propagation on ajoute au signal filtré un bruit gaussien d'écart type paramètrable.

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/Signal%20%2B%20bruit.PNG)

On va ensuite utiliser le niveau moyen du signal sur une période pour discriminer un bit 1 d'un bit 0 et comparer les signaux en entrée et en sortie du canal. On compte le nombre de bit faux sur le nombre de bit total pour obtenir le rapport signal sur bruit.

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/d%C3%A9cision%20et%20taux%20derreur.PNG)

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/signal%20filtr%C2%82.PNG)

![](https://github.com/melurne/TP_TIM/blob/master/images/Scilab/Signal_recompose.PNG)

Par nos essais, nous avons pu determiner que pour obtenir un TEB inférieur à 1/100, il faut un rapport signal sur bruit inférieur à 0.157 et qu'un TEB inférieur à 1/1000 n'est pas atteignable dans notre simulation.

## Conclusion

Dans ce TP nous avons pu voir les différentes méthodes de codages pour une transmission en bande de base. Nous avons pu constater et comparer les avantages et inconvénients de codages comme le codage Manchester et NRZ bipolaire. Ce TP nous aura aussi permis de découvrir comment peuvent se calculer des signaux numériques à l’aide de code informatique.

# Chaine De Transmission RF

Pour ce TP, nous allons réaliser le montage schématisé ci-dessous :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/SchemaChaineDeTranmission.png)

Le but du montage est de simuler une chaîne de transmission modulée QPSK comprenant l’émission et la réception d’un signal numérique.

## Modulation du signal

Pour réaliser une modulation QPSK, nous allons utiliser un modulateur IQ qui permet une modulation de phase en fonction de ses entrées I et Q. Un bit sur deux est envoyé dans la voie I et l’autre partie dans la voie Q. Ainsi, on obtient en sortie différents états de phase correspondant aux états possibles de I et Q. Ainsi cela permet de doubler le débit d’informations que l’on envoie tout en gardant la même bande passante, ce qui permet une meilleure efficacité spectrale.

On utilise le génerateur de signal aléatoire pour générer les composantes I et Q du signal à transmettre. Notre modulateur fonctionne à 70 MHz, on doit donc génerer une porteuse à 70 MHz par un premier VCO, on s'assure de la fréquence à l'aide de l'analyseur de spectre :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/VCO1.jpg)

Ce qui nous donne un message modulé autour des 70 MHz :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/MessageModul%C3%A9.jpg)

Notre démodulateur lui fonctionne à 870 MHz, il faut donc remoduler notre signal pour le transposer à 870 MHz grâce à un multiplieur et un second VCO à 800 MHz. On s'assure également de la fréquence du second VCO à l'analyseur de spectre :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/VCO2.jpg)

Nous avons donc en sortie du multiplieur notre signal avec la porteuse autour de 870 MHz :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/Message%2BPorteuse.jpg)

## Démodulation du signal

Pour démoduler le signal à la sortie, on a besoin de récuperer la porteuse dans le signal, traditionnelement à l'aide d'une PLL. Dans notre cas on n'as pas de PLL à notre disposition, on va donc récuperer la porteuse directement en sortie du second VCO.

Nous avons donc un montage final comme ci-dessous :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/Montage.jpg)

## Constellation QPSK

Pour observer la constellation QPSK on observe le signal transmis à l'oscilloscope en mode XY :

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/Constellation.jpg)

Le diagramme que l'on obtient est tourné par rapport à ce que l'on aurait dû obtenir. Cela vient du déphasage entre la porteuse génerée par le VCO et celle qui a été mélangée au signal.

En effet la référence du diagramme (l'horizontale) est définie par l'entrée "porteuse" du démodulateur.

![](https://github.com/melurne/TP_TIM/blob/master/images/ChaineDeTransmission/schema_constellation.png)

## Conclusion

Nous avons réalisé un système d’émission / réception à l’aide d’une modulation 4 - QPSK. Pour ce faire, nous avons donc utilisé un modulateur IQ. Pour atteindre les 70 MHz de ce modulateur, nous avons mélanger le signal avec une porteuse de 70 MHz à l'aide d'un VCO. Puis nous avons de nouveau mélanger ce signal de 70 MHz à une deuxième porteuse de 800 MHz afin de pouvoir s'aligner sur la fréquence du démodulateur côté réception. La démodulation du signal reçu s'effectue avec un signal de référence de même fréquence et ayant pour phase celle de l’oscillateur local de l’émission. En temps normal il faudrait utiliser une PLL pour obtenir cette référence, mais nous avons préféré utiliser directement le signal de l’oscillateur local car c’est une solution plus simple ici. 
En observant le diagramme de constellation de l’information récupéré, on remarque que cette dernière n’est pas parfaitement récupérée.
