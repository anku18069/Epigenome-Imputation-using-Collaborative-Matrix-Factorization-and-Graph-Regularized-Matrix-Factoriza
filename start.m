clear all

%-------------------------------------------------------------------

diary off; diary on;
fprintf('\nSTART TIME:    %s\n\n', datestr(now));

%-------------------------------------------------------------------

global predictionMethod gridSearchMode

gridSearchMode = 0;   % grid search mode?
% if turned on:
% - suppresses printing of intermediate fold results on screen
% - prevents saving of prediction scores

% prediction method: 
% 'np', 'wp', 'rls_wnn', 'nbi', 'kbmf2k', 'grmf', 'cmf', 'sitar'
%predictionMethods = {'np', 'wp', 'rls_wnn', 'nbi', 'kbmf2k', 'grmf', 'cmf', 'sitar', 'laprls'};
predictionMethods = {'cmf', 'grmf'};
warning off

%-------------------------------------------------------------------

global m n Sd St ds cv_setting

% The location of the folder that contains the data
path='data\';

% the different datasets
datasets={'epigenome'};

% CV parameters
m = 1;  % number of n-fold experiments (repetitions)
n = 5; % the 'n' in "n-fold experiment"

%-------------------------------------------------------------------

disp(['gridSearchMode = ' num2str(gridSearchMode)])
disp(' ')

diary off; diary on;

%-------------------------------------------------------------------
for p=1:length(predictionMethods)
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    predictionMethod = predictionMethods{p};

    % loop over all cross validation settings
    for cvs=1:3
        disp('===========================================');
        disp(['Prediction method = ' predictionMethod])
        cv_setting = ['S' int2str(cvs)];
        switch cv_setting
            case 'S1', disp('CV Setting Used: S1 - PAIR');
            case 'S2', disp('CV Setting Used: S2 - CELL');
            case 'S3', disp('CV Setting Used: S3 - Chromatin Site');
        end
        disp(' ')

        % run chosen selection method and output CV results
        for ds=[1]
            getParameters(predictionMethod, cv_setting, ds);
            disp('-----------------------');

            fprintf('\nData Set: %s\n', datasets{ds});

            % LOAD DATA
            %[Y,Sd,St,~,~]=getdata(path,datasets{ds});
            [Y,Sd,St,~,~]=getdata1(path,datasets{ds});

            % CV experiment
            tic
            crossValidation(Y);
            disp(' ')
            toc

            disp('-----------------------');
            diary off; diary on;
        end
        
        disp('===========================================');
        diary off; diary on;
    end

    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    diary off; diary on;
end
diary off;

%-------------------------------------------------------------------
