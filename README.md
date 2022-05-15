# Codage et Transmission en bande de base

## Partie 1

On génère un vacteur rempli aléatoirement de 0 et de 1 qui ferra office de message à transmettre. 

![graph vecteur pas bo](/home/maxence/TP_TIM/images/Scilab/Message%20binaire.PNG)

Pour que la modulation soit plus propre, on a besoin de convertir ce vecteur en une représentation d'un signal carré (étendre chaque bit sur une période).

![Message codé](/home/maxence/TP_TIM/images/Scilab/info%20code.PNG)

---

### Codage NRZ

On fait correspondre 

> Un bit à 0 -> -5V
> 
> Un bit à 1 -> +5V

![NRZ](/home/maxence/TP_TIM/images/Scilab/info%20code%20bip.PNG)

### Codage Manchester

On implémente un codage Manchesterpour la transmission du signal, ce codage transforme un bit du signal en une période d'un du nouveau signal et en faisant correspondre

> Un bit à 0 -> un front montant
> 
> Un bit à 1 -> un front descendant

![Manchester](/home/maxence/TP_TIM/images/Scilab/mach%20+%20bip.PNG)

---

## FFT

L'utilisation du codage Manchester amène un premier zéro 2 foix plus éloigné qu'en bande de base de par la substitution d'un bit en bande de base par une période de signal au lieu d'une demi en bande de base. Le lobe du codage Manchester est donc deux fois plus grand que celui en bande de base.

 ![](/home/maxence/TP_TIM/images/Scilab/dsp%20100.PNG)

## Filtrage

Pour simuler l'action d'un canal de transmission, on va filtrer le signal afin de ne transmettre que le premier lobe de la FFT. Pour cela on annule le signal à partir du premier echantillon au dessous de 0.

![](/home/maxence/TP_TIM/images/Scilab/filtrage%20nrz.PNG)

## Inclusion de bruit

Pour simuler l'effet d'un canal de propagation on ajoute au signal filtré un bruit gaussien d'écart type paramètrable.

On va ensuite utiliser le niveau moyen du signal sur une période pour discriminer un bit 1 d'un bit 0 et comparer les signaux en entrée et en sortie du canal. On compte le nombre de bit faux sur le nombre de bit total pour obtenir le rapport signal sur bruit.



# Chaine De Transmission RF

On va réaliser le montage schématisée si dessous :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/SchemaChaineDeTranmission.png)

Le but du montage est de simuler une chaîne de transmission modulée QPSK.

On utilise le génerateur de signal aléatoire pour générer les composantes I et Q du signal à transmettre. Notre modulateur fonctionne à 70 MHz, on doit donc génerer une porteuse à 70 MHz par un premier VCO, on s'assure de la fréquence à l'aide de l'analyseur de spectre :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/VCO1.jpg)

Notre démodulateur lui fonctionne à 870 MHz, il faut donc remoduler notre signal pour le transposer à 870 MHz grâce à un multiplieur et un second VCO à 800 MHz. On s'assure également de la fréquence à l'analyseur de spectre :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/VCO2.jpg)

On observe alors à l'analyseur de spectre le Message modulé en sortie du modulatuer (autour de 70 MHz) :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/MessageModulé.jpg)

Puis avec la porteuse en sortie du multiplieur (autour de 870 MHz) :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/Message+Porteuse.jpg)



Pour démoduler le signal à la sortie, on a besoin de récuperer la porteuse dans le signal, traditionnelement à l'aide d'une PLL. Dans notre cas on n'as pas de PLL à notre disposition, on va donc "tricher" et récuperer la porteuse directement en sortie du second VCO.



Pour observer la constellation QPSK on observe le signal transmis à l'oscilloscope en mode XY :

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/Constellation.jpg)



Le diagramme que l'on obtient est tourné par rapport à ce que l'on aurait dû obtenir. Cela vient du déphasage entre la porteuse génerée par le VCO et celle qui a été mélangée au signal.

En effet la référence du diagramme (l'horizontale) est définie par l'entrée "porteuse" du démodulateur.

![](/home/maxence/TP_TIM/images/ChaineDeTransmission/schema_constellation.png)
