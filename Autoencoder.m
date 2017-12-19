%% CS 532 Final Project -- Rita Roloff, Justin Essert, Aaron Levin
close all; clear all;
%% Load data
train_images = loadMNISTImages('MNIST/train-images-idx3-ubyte');
train_labels = loadMNISTLabels('MNIST/train-labels-idx1-ubyte');

test_images = loadMNISTImages('MNIST/t10k-images-idx3-ubyte');
test_labels = loadMNISTLabels('MNIST/t10k-labels-idx1-ubyte');

% Training and testing images are known to be 28x28 from the dataset
% specifications, but, the manner in which we are loading them puts them
% into a neural-network-friendly 2D format of: 
%   784x60000 (training images)
%   784x10000 (testing images)
%   60000x1   (training labels)
%   10000x1   (testing labels)

%% Setup hyperparameters

num_hidden = 100;   % number of hidden 
act_func = 1;       % activation function
alpha = 1e-8;       % step size
lambda = 0;      % regularization parameter
epsilon = 1e-3;     % convergence factor
batch = 1000;        % batch size
max_epoch = 10;      % number of training iterations to run

%% Train Network
lambda = [0,.1, .01, .001];
figure(1); hold on;
for i=1:size(lambda,2)
    [ w, v, loss ] = train_network(train_images, train_images, num_hidden, act_func, alpha, epsilon,lambda(i), batch, max_epoch );
    t = size(loss,2);
    if(t==max_epoch)
        disp(['Did not converge, stopped after ' num2str(t), ' epochs']);
    else
        disp(['Converged after ' num2str(t), ' epochs']);
        loss=[loss zeros(1, max_epoch-t)];
    end
    plot(1:max_epoch,loss);
    
    leg(i) = "lambda = "+num2str(lambda(i));
end
legend(leg);
hold off;

%% Test Autoencoder

% Training Set Error
[m,n] = size(train_images);
h_p = [ones(n,1) train_images'] * w;
h = [ones(n,1) act(h_p, act_func)];
o_p = h * v;
o = act(o_p, act_func);

loss = norm(o - train_images')


