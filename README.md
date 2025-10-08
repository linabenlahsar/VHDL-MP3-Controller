# VHDL-MP3-Controller
Projet VHDL : lecteur MP3 simplifié sur FPGA Nexys4 (compteurs, FSM, afficheurs 7 segments)
# Lecteur MP3 - Projet VHDL sur Nexys4

# Objectif
Conception d’une architecture en VHDL sur carte FPGA *Nexys4 (Artix-7)* permettant de gérer :
- Un compteur/décompteur 1–599 avec affichage sur 7 segments
- Un compteur volume 1–9
- Une machine à états finis (FSM) 
- L’affichage multi-7-segments (8 digits)

# Architecture
Le projet est divisé en plusieurs modules VHDL :
- `gestion_freq.vhd` : génération des signaux d’horloge CE (3 kHz et 10 Hz)
- `detec_impulsion.vhd` : filtrage et détection des appuis boutons
- `fsm_MP3.vhd` : machine à états finis
- `cpt_1_599.vhd` et `cpt_1_9.vhd` : compteurs
- `trans.vhd` : transcodage vers 7 segments
- `mod8.vhd` et `mux8.vhd` : gestion des 8 afficheurs 7 segments

# Résultats
- Simulation sous Vivado (100 MHz)
- Fonctionnement validé par testbenchs
- Affichage correct sur carte Nexys4

![waveforms](results/simulation_waveforms.png)

# Outils
- Langage : VHDL
- FPGA: Xilinx Artix-7 (Nexys4)
- IDE : Xilinx Vivado

# Auteurs
-Lina Benlahsar
-Zayd Chamcham
