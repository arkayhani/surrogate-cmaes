classdef OrigRatioUpdaterFactory
  methods (Static)
    function obj = createUpdater(surrogateOpts)
      switch lower(surrogateOpts.updaterType)
        case 'rmse'
          obj = OrigRatioUpdaterRMSE(surrogateOpts.updaterParams);
        otherwise
          % including surrogateOpts.updaterType == 'constant'
          %
          % this awfull code is due to backward-compatibility O:-)
          if ~(isfield(surrogateOpts, 'updaterParams'))
            if ~(isfield(surrogateOpts, 'origEvalsRatio'))
              if ~(isfield(surrogateOpts, 'restrictedParam'))
                error('There''s not a parameter for ConstantRatioUpdater');
              else
                p = surrogateOpts.restrictedParam;
              end
            else
              p = surrogateOpts.origEvalsRatio;
            end
          else
            p = surrogateOpts.updaterParams;
          end
          
          obj = OrigRatioUpdaterConstant(p);
      end
    end
  end
end