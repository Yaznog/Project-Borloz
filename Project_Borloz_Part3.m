%% Cas où Ns = 2 < Nc = 5

clc
clear
close all


% Initialisation ----------------------------------------------------------

Ns = 2;
Nc = Ns;
fe = 8192;
i0 = 2;

Ode = importdata('ode-a-la-joie.wav');
Moonlight = importdata('moonlight.wav');

ode = Ode.data;
moonlight = Moonlight.data;
fe = Ode.fs;

N = max(length(moonlight) , length(ode));
moonlight = [moonlight ; zeros(N-length(moonlight),1)];
ode = 0.7*[ode ; zeros(N-length(ode),1)];

X = [ode' ; moonlight'];
Nb = 2000;

menu_music = menu('Ecoute des sources','Ode à la joie','Moonlight Sonata', 'Aucune');
if menu_music == 1
    sound(X(menu_music,:),fe);
elseif menu_music == 2
    sound(X(menu_music,:),fe);
end

% Definition de Y ---------------------------------------------------------

M =  [1 1 ; 1.8 1.3 ; 0.55 1.8 ; 1.2 0.8 ; 1 1.25];
Y = M*X;

menu_music = menu('Ecoute des observations','Y(1)','Y(2)', 'Aucune');
if menu_music == 1
    sound(Y(menu_music,:),fe);
elseif menu_music == 2
    sound(Y(menu_music,:),fe);
end

% Definition de Z ---------------------------------------------------------

U = inv(M');
S = U';

Z = S*Y;

% Autocorrélation ---------------------------------------------------------

for i=1:Ns
    PhiXX(i,:) = Autocorrelation(X(i,:),N,Nb);
end

% Intercorrélation --------------------------------------------------------

k=1;
for i=1:Nc
    for j=1:Ns
        PhiXY(k,:) = Intercorrelation(X(j,:),Y(i,:),N,Nb);
        k = k+1;
    end
end

% Subplot -----------------------------------------------------------------

figure(1)
nb_col_subplot = 3;
nb_lig_subplot = max(Ns,Nc);

for i=1:Ns
    subplot(nb_lig_subplot, nb_col_subplot,3*i-2)
    plot(X(i,:))
    title('Source(s)');
end

for i=1:Nc
    subplot(nb_lig_subplot, nb_col_subplot,3*i-1)
    plot(Y(i,:))
    title('Y');
end

for i=1:Ns
    subplot(nb_lig_subplot, nb_col_subplot,3*i)
    plot(Z(i,:))
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
