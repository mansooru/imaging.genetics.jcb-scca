% --------------------------------------------------------------------
% Example script for JCB-SCCA algorithm
% Multi-modal SCCA algorithm handle group lasso and brain connectivity 
% 
% Sample data for real PD dataset is provided
% 
% Homepage: https://github.com/mansooru/imaging.genetics.jcb-scca
% Author: Mansu Kim, mansooru@skku.edu
% Date created: July-30-2018
% @Sungkyunkwan University
% --------------------------------------------------------------------

%% Demonstrate using simulated data
clear all; clc;

addpath ../01_code

% Setting initial information
n = 100;
p = 90;
q = 650;
class = 2;

sig_noise = 1.5; % Change if necessary

% Ground truth
u0_gt = [ones(1,3) zeros(1,25) ones(1,2) zeros(1,20) ones(1,10) zeros(1,20) ones(1,2) zeros(1,25) ones(1,3)  zeros(1,10) ones(1,10) zeros(1,10) ones(1,10) zeros(1,50) ones(1,50) zeros(1,400)];
v0_gt = [ones(1,1) zeros(1,20) ones(1,2) zeros(1,20) ones(1,2) zeros(1,20) ones(1,5) zeros(1,20) ];
v1_gt = [ones(1,1) zeros(1,35) ones(1,2) zeros(1,5) ones(1,2) zeros(1,20) ones(1,5) zeros(1,20) ];

% Generate latent variable
z = randn(n,1);
z = sign(z).*(abs(z)+0.1);
z = zscore(z);
z1 = randn(n,1);
z1 = sign(z1).*(abs(z1)+0.1);
z1 = zscore(z1);

% Generate X and Y
data.X{1,1} = z*u0_gt + randn(n,q)*sig_noise;
data.X{2,1} = data.X{1};
data.Y{1,1} = z*v0_gt + randn(n,p)*sig_noise;
data.Y{2,1} = z*v1_gt + randn(n,p)*sig_noise;
data.class = 2;

% Calculate connectivity penalty
data.PX{1,1} = get_connectivity(data.X{1,1},2);
data.PX{2,1} = data.PX{1,1};
data.PY{1,1} = get_connectivity(data.Y{1,1},2);
data.PY{2,1} = get_connectivity(data.Y{2,1},2);

% Normalization
data.X{1,1} = zscore(data.X{1});
data.X{2,1} = data.X{1};
data.Y{1,1} = zscore(data.Y{1});
data.Y{2,1} = zscore(data.Y{2});

% Run joint connectivity sparse CCA
para = [200 50 0.1 0.1 0.1 0.1];  % Change if necessary
u0 = ones(q,1)./q;
v0 = ones(p,1)./p;
[u,v,obj] = jcbscca(data,para,u0,v0);


% visualization of loading vectors
v1(:,:) = v(:,:,1);
v2(:,:) = v(:,:,2);

figure
subplot(311);
stem(u0_gt);
title('Ground truth: u0 , A genetic variants');
subplot(312);
stem(v0_gt);
title('Ground truth: v1 , First neuroimaing features');
subplot(313);
stem(v1_gt);
title('Ground truth: v2 , Second neuroimaing features');

% visualization of loading vectors
figure
subplot(311);
stem(u');
title('Estimated loading vector: u0 , A genetic variants');
subplot(312);
stem(v1');
title('Estimated loading vector: v1 , First neuroimaing features');
subplot(313);
stem(v2');
title('Estimated loading vector: v2 , Second neuroimaing features');
