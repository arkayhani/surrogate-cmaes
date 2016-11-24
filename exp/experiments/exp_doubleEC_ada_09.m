exp_id = 'exp_doubleEC_ada_09';
exp_description = 'Surrogate CMA-ES in 5D, adaptive DTS, updateRate=0.3, updateRateDown=updateRate, highErr=0.35, DTIterations=2, ValidationGenerationPeriod={1, 3, 5, 10}, ValidationPopSize={0, 5, 10, 15}, OrigPointsRoundFcn={''ceil'', ''getProbNumber''}, PreSampleSize=0.75, sd2 criterion, 2pop';

% BBOB/COCO framework settings

bbobParams = { ...
  'dimensions',         { 5 }, ...
  'functions',          { 2, 3, 6, 8, 13, 17, 21 }, ...  % all functions: num2cell(1:24)
  'opt_function',       { @opt_s_cmaes }, ...
  'instances',          { [1:5 41:50] }, ...    % default is [1:5, 41:50]
  'maxfunevals',        { '250 * dim' }, ...
  'resume',             { true }, ...
};

% Surrogate manager parameters

surrogateParams = { ...
  'evoControl',         { 'doubletrained' }, ...
  'observers',          { {'DTScreenStatistics', 'DTFileStatistics'} },...
  'modelType',          { 'gp' }, ...
  'updaterType',        { 'rankDiff' }, ...          % i.e. OrigRatioUpdaterRankDiff2
  'DTAdaptive_aggregateType',  { 'lastValid' }, ...
  'DTAdaptive_updateRate',     { 0.3 },...           % { 0.15, 0.2, 0.25, 0.30, 0.35, 0.40, 0.45, 0.5 }, ...
  'DTAdaptive_updateRateDown', {'obj.updateRate'}, ...
  'DTAdaptive_maxRatio',       { 1.0 }, ...
  'DTAdaptive_minRatio',       { 0.04 }, ...         % 0.05 should be used only for 10D and 20D
  'DTAdaptive_lowErr',         { 0.10 }, ...         % { 0.10, 0.15 }, ...
  'DTAdaptive_highErr',        { 0.35 }, ...               % { 0.30, 0.35, 0.40 }, ...
  'DTAdaptive_defaultErr',     { '(obj.highErr + obj.lowErr) / 2' }, ...
  'evoControlMaxDoubleTrainIterations',   { 2 }, ...   % use {1, 2, 3, Inf} with the best settings afterwards
  'evoControlValidationGenerationPeriod', {1, 3, 5, 10}, ...
  'evoControlValidationPopSize',   {0, 5, 10, 15}, ...
  'evoControlPreSampleSize',       { 0.75 }, ...     % use { 0, 0.25, 0.50, 0.75 } with the best settings afterwards
  'evoControlOrigPointsRoundFcn',  { 'ceil', 'getProbNumber' }, ...  % either 'ceil', or 'getProbNumber'
  'evoControlTrainRange',          { 10 }, ...       % will be multip. by sigma
  'evoControlTrainNArchivePoints', { '15*dim' },...  % will be myeval()'ed, 'nRequired', 'nEvaluated', 'lambda', 'dim' can be used
  'evoControlSampleRange',         { 1 }, ...        % will be multip. by sigma
};

% Model parameters

modelParams = { ...
  'useShift',           { false }, ...
  'predictionType',     { 'sd2' }, ...
  'trainAlgorithm',     { 'fmincon' }, ...
  'covFcn',             { '{@covMaterniso, 5}' }, ...
  'hyp',                { struct('lik', log(0.01), 'cov', log([0.5; 2])) }, ...
  'normalizeY',         { true }, ...
};

% CMA-ES parameters

cmaesParams = { ...
  'PopSize',            { '(8 + floor(6*log(N)))' }, ...        % default CMA-ES PopSize is '(4 + floor(3*log(N)))';
  'Restarts',           { 50 }, ...
  'DispModulo',         { 0 }, ...
};

logDir = '/storage/plzen1/home/bajeluk/public';