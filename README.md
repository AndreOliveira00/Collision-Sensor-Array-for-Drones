# Collision Sensor Array for Drones
 Collision Sensor Array for Drones using ToF and Solid State LiDAR

Este repositório contem o poster ilustrativo do projeto desenvolvido durante o estágio de fim de Licenciatura em Engenharia Eletrotécnica e de Computadores pelo Instituto Superior de Engenharia do Porto.
Contem ainda parte do código desenvolvido para controlo de todos os dispositivos incorporados na rede daisy chain.

RESUMO DO PROJETO:

O projeto apresentado neste documento consiste num sistema embebido para controlo de abertura e fecho de uma claraboia incorporada no tejadilho dos autocarros. A solução desenvolvida procurou a adaptabilidade a diferentes veículos, pelo que permitirá o controlo por parte do utilizador, sem maiores dificuldades, seguindo assim o conceito de Smart City.
O sistema visa a robustez sendo implícito a implementação das boas práticas Electromagnetic compatibility (EMC) e cumpridor da norma UNECE R10 no momento de dimensionamento do hardware associado. Os testes ao sistema desenvolvido foram feitos num laboratório isolado, com alimentação de uma bateria externa, com recurso a um analisador de espetro e sondas EMC.
O movimento rotativo do motor passo a passo NEMA 23 encontra-se acoplado com uma engrenagem módulo 1,5 capaz de elevar a estrutura por 7 cm. Este movimento é visível nos dois extremos da claraboia com auxílio de dois motores, sendo esta estrutura rígida.
O dispositivo de controlo principal é constituído por um microcontrolador Advanced RISC Machine (ARM) Cortex M4 de 32 bits, o STM32F401RET6 baseado numa arquitetura Reduced Instruction Set Computer (RISC), responsável por controlar os dois drivers junto 
dos referidos motores. Estes drivers incorporam um dispositivo de comando das fases, o powerSTEP01, com controlo programável através de Serial Peripheral Interface (SPI).
A comunicação entre o dispositivo principal e os drivers é feita através do protocolo de comunicação SPI segundo uma topologia em daisy chain atuando este primeiro como mestre e os restantes como escravos. Adicionalmente foi alvo de estudo a necessidade de 
implementação de uma comunicação RS-485 entre os dois escravos fruto de um sistema funcional num ambiente sujeito a ruído eletromagnético.

Para outros esclarecimentos contacte pelo email 1181045@isep.ipp.pt.

Notas:
  O desenvolvimento do software foi feito em: "...STM32CubeExpansion_SPN3\Projects\Multi\Examples\MotionControl\IHM03A1_ExampleFor1Motor"
