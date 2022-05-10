%% Cas où Ns = 2 Nc = 3

clc
clear
close all

% Initialisation ----------------------------------------------------------

M =  [1 1 ; 1.8 1.3 ; 0.55 1.8];

Ns = length(M(1,:));
Nc = length(M(:,1));
i0 = 2;
Nb = 400;

dataH = load('handel.mat');
dataL = load('laughter.mat');

Handel = dataH.y;
Laughter = dataL.y;
fe = dataH.Fs;

clear dataH dataL;

N = min(length(Handel) , length(Laughter));
Handel = Handel(1:N,1);
Laughter = Laughter(1:N,1);

X = [Handel' ; Laughter'];

menu_music = menu('Ecoute des sources','Handel','Laughter', 'Aucune');
if menu_music == 1
    sound(X(menu_music,:),fe);
elseif menu_music == 2
    sound(X(menu_music,:),fe);
end
clear menu_music;

% Definition de Y ---------------------------------------------------------

Y = M*X;

menu_music = menu('Ecoute des observations','Y(1)','Y(2)', 'Aucune');
if menu_music == 1
    sound(Y(menu_music,:),fe);
elseif menu_music == 2
    sound(Y(menu_music,:),fe);
end
clear menu_music;

% Autocorrélation de X ----------------------------------------------------

for i=1:Ns
    for j=1:Nb
        PhiXX(i,j) = Autocorrelation(X(i,:),N,j);
    end
end

% Intercorrélation --------------------------------------------------------

k=1;
for i=1:Nc
    for j=1:Ns
        for l=1:Nb
            PhiXY(k,l) = Intercorrelation(X(j,:),Y(i,:),N,l);
        end
        k = k+1;
    end
end

% Création de GammaX ------------------------------------------------------

% for i=1:Nb
%     for j=1:Nc
%         for k=1:Nc
%             GammaX(j,k,i) = Intercorrelation(X(j,:),X(k,:),N,i);
%         end
%     end
% end

% Création de GammaY -------------------------------------------------------

for i=1:Nb
    for j=1:Nc
        for k=1:Nc
            GammaY(j,k,i) = Intercorrelation(Y(j,:),Y(k,:),N,i);
        end
    end
end

% Création de DeltaY ------------------------------------------------------

DeltaY_i0 = inv(GammaY(:,:,1))*GammaY(:,:,i0+1);

% Création de U -----------------------------------------------------------

[Delta,ValP] = eig(DeltaY_i0);
for i=1:length(Delta(1,:))
    U(:,i) = Delta(:,i)./norm(Delta(:,i));
end

% Definition de Z ---------------------------------------------------------

W = U.';
% S = U.';
Z = W*Y;

Amplification = 1;

Z = Amplification.*Z;

menu_music = menu('Ecoute des signaux séparés','Z(1)','Z(2)', 'Aucune');
if menu_music == 1
    sound(Z(menu_music,:),fe);
elseif menu_music == 2
    sound(Z(menu_music,:),fe);
end
clear menu_music;

% Subplot -----------------------------------------------------------------

figure(1)
nb_col_subplot = 3;
nb_lig_subplot = max(Ns,Nc);
t = [0:N-1]/fe;

for i=1:Ns
    subplot(nb_lig_subplot, nb_col_subplot,3*i-2)
    plot(t,X(i,:))
    title('Source(s)');
end

for i=1:Nc
    subplot(nb_lig_subplot, nb_col_subplot,3*i-1)
    plot(t,Y(i,:))
    title('Y');
end

for i=1:Ns
    subplot(nb_lig_subplot, nb_col_subplot,3*i)
    plot(t,Z(i,:))
    title('Z');
end

figure(2)
nb_col_subplot = Nc+1;
nb_lig_subplot = Ns;

for i=1:Ns
    subplot(nb_lig_subplot, nb_col_subplot,(Nc+1)*(i-1)+1)
    plot(PhiXX(i,:))
    title('PhiXX');
end

for j=1:Nc
    for i=1:Ns
        subplot(nb_lig_subplot, nb_col_subplot,(Nc+1)*(i-1)+j+1)
        plot( PhiXY( i+Ns*(j-1) , :) )
        title('PhiXY');
    end
end

clear nb_col_subplot nb_lig_subplot i j t k;
